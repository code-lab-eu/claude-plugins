#!/usr/bin/env bash
# Removes the ticket worktrees whose work is merged.
#
# Usage: prune-worktrees.sh
#
# For each worktree under `.claude/worktrees/` of the main checkout: removes
# the worktree and deletes its local branch when the branch is merged into
# `origin/master` and the worktree has no uncommitted changes. A finished
# Claude Code session in the worktree is stopped first, and its worktree lock
# released. A worktree with a working or blocked session is kept.
#
# Prints one line per worktree: `removed <path> <branch>` or
# `kept <path> <reason>`. Exits non-zero with a one-line reason on stderr when
# the repository cannot be read or a removal fails.
set -euo pipefail

die() {
  echo "prune-worktrees: $*" >&2
  exit 1
}

common_dir=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null) ||
  die "not inside a git repository"
main=$(dirname "$common_dir")
cd "$main"
root="$main/.claude/worktrees"

git fetch --quiet origin || die "git fetch origin failed"
sessions=$(claude agents --json --all) || die "claude agents failed"

# `git worktree list --porcelain` prints one block per worktree: a `worktree
# <path>` line, then `branch refs/heads/<name>` or `detached`.
paths=()
branches=()
while read -r key value; do
  case $key in
    worktree)
      paths+=("$value")
      branches+=("")
      ;;
    branch) branches[${#branches[@]} - 1]=${value#refs/heads/} ;;
  esac
done < <(git worktree list --porcelain)

for i in "${!paths[@]}"; do
  path=${paths[$i]}
  branch=${branches[$i]}
  [[ $path == "$root"/* ]] || continue

  if [ ! -d "$path" ]; then
    echo "kept $path directory is missing; run git worktree prune"
    continue
  fi
  if [ -z "$branch" ]; then
    echo "kept $path detached HEAD"
    continue
  fi
  if ! git merge-base --is-ancestor "refs/heads/$branch" origin/master; then
    echo "kept $path $branch is not merged into origin/master"
    continue
  fi
  if [ -n "$(git -C "$path" status --porcelain)" ]; then
    echo "kept $path uncommitted changes"
    continue
  fi
  active=$(jq -r --arg cwd "$path" \
    '[.[] | select(.cwd == $cwd and (.state == "working"
      or .state == "blocked" or .kind == "interactive")) | .id // .pid]
      | first // empty' <<<"$sessions")
  if [ -n "$active" ]; then
    echo "kept $path session $active is active"
    continue
  fi

  # A finished background session whose process still runs holds the
  # worktree lock.
  while read -r id; do
    claude stop "$id" >/dev/null || die "claude stop $id failed"
  done < <(jq -r --arg cwd "$path" \
    '.[] | select(.kind == "background" and .cwd == $cwd
      and .pid != null) | .id' <<<"$sessions")
  git worktree unlock "$path" 2>/dev/null || true
  git worktree remove "$path" || die "git worktree remove $path failed"
  # `-D`: the merge into `origin/master` is checked above. `-d` compares with
  # the branch's upstream or the local HEAD instead, which lag behind after a
  # merged PR branch is deleted on GitHub.
  git branch --quiet -D "$branch" || die "git branch -D $branch failed"
  echo "removed $path $branch"
done
