#!/usr/bin/env bash
# Creates or updates the git worktree a ticket session works in.
#
# Usage: create-worktree.sh <ticket> <fix|new>
#
# The worktree is `.claude/worktrees/<ticket>` in the main checkout, on branch
# <ticket>. `fix` checks out the existing branch `origin/<ticket>` of a PR
# under review, or fast-forwards a worktree that already exists. `new` starts
# the branch from `origin/master`. The repository's `info/exclude` gets the
# entry that keeps the session report, `.ticket-report.md` in the worktree,
# out of git. Afterwards the main checkout's
# `scripts/worktree-setup.sh <main-checkout>`, when present and executable,
# runs with the worktree as the working directory. The main checkout's copy
# is used because branches made before the script was added do not have it.
#
# On success prints `worktree <ticket> <path>`. On a refused case prints one
# line with the reason to stderr and exits non-zero.
set -euo pipefail

die() {
  echo "create-worktree: $*" >&2
  exit 1
}

[ "$#" -eq 2 ] || die "usage: create-worktree.sh <ticket> <fix|new>"
ticket=$1
mode=$2
[[ $ticket =~ ^T[0-9]+$ ]] || die "ticket '$ticket' does not match T<number>"
[[ $mode == fix || $mode == new ]] || die "mode '$mode' is not fix or new"

common_dir=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null) ||
  die "not inside a git repository"
main=$(dirname "$common_dir")
cd "$main"
worktree="$main/.claude/worktrees/$ticket"

git fetch --quiet origin || die "git fetch origin failed"

remote_exists=false
git rev-parse --verify --quiet "refs/remotes/origin/$ticket" >/dev/null &&
  remote_exists=true
local_exists=false
git rev-parse --verify --quiet "refs/heads/$ticket" >/dev/null &&
  local_exists=true

# A second session in the same worktree would compete with the first.
active=$(claude agents --json |
  jq -r --arg cwd "$worktree" \
    '[.[] | select(.kind == "background" and .cwd == $cwd
      and (.state == "working" or .state == "blocked")) | .id]
      | first // empty') || die "claude agents failed"
[ -z "$active" ] || die "$ticket: session $active is still active in $worktree"

# Brings the worktree's branch up to date with `origin/<ticket>`. Refuses when
# it has uncommitted changes or commits that are not on the remote branch.
fast_forward() {
  [ -z "$(git -C "$worktree" status --porcelain)" ] ||
    die "$ticket: worktree $worktree has uncommitted changes"
  if git -C "$worktree" merge-base --is-ancestor HEAD "origin/$ticket"; then
    git -C "$worktree" merge --quiet --ff-only "origin/$ticket" ||
      die "$ticket: fast-forward to origin/$ticket failed"
  elif ! git -C "$worktree" merge-base --is-ancestor "origin/$ticket" HEAD; then
    die "$ticket: branch has diverged from origin/$ticket"
  fi
}

if [ "$mode" = fix ]; then
  $remote_exists || die "$ticket: origin/$ticket does not exist"
  if [ -e "$worktree" ]; then
    [ "$(git -C "$worktree" rev-parse --show-toplevel 2>/dev/null)" = \
      "$worktree" ] || die "$ticket: $worktree is not a git worktree"
    branch=$(git -C "$worktree" symbolic-ref --quiet --short HEAD) ||
      die "$ticket: $worktree is not a worktree on a branch"
    [ "$branch" = "$ticket" ] ||
      die "$ticket: $worktree is on branch $branch, not $ticket"
    fast_forward
  elif $local_exists; then
    git worktree add --quiet "$worktree" "$ticket" >&2 ||
      die "$ticket: git worktree add failed"
    fast_forward
  else
    git worktree add --quiet --track -b "$ticket" "$worktree" \
      "origin/$ticket" >&2 || die "$ticket: git worktree add failed"
  fi
else
  ! $remote_exists || die "$ticket: origin/$ticket already exists"
  ! $local_exists || die "$ticket: local branch $ticket already exists"
  [ ! -e "$worktree" ] || die "$ticket: $worktree already exists"
  # `--no-track` keeps `origin/master` from becoming the branch's upstream.
  git worktree add --quiet --no-track -b "$ticket" "$worktree" \
    origin/master >&2 || die "$ticket: git worktree add failed"
fi

# The ticket session writes its report to `.ticket-report.md` at the root of
# its worktree. The repository's `info/exclude`, which all its worktrees
# share, keeps the report out of `git status` and out of commits.
exclude="$common_dir/info/exclude"
mkdir -p "$common_dir/info"
grep -qxF "/.ticket-report.md" "$exclude" 2>/dev/null ||
  echo "/.ticket-report.md" >>"$exclude"

setup="$main/scripts/worktree-setup.sh"
if [ -x "$setup" ]; then
  (cd "$worktree" && "$setup" "$main") >&2 ||
    die "$ticket: $setup failed in $worktree"
fi

echo "worktree $ticket $worktree"
