#!/usr/bin/env bash
# Starts a background Claude Code session in a ticket's worktree.
#
# Usage: launch-session.sh <ticket> <fix|new> [<pr>]
#
# Run create-worktree.sh first. The session starts from the main checkout with
# `--worktree <ticket>`, which opens the existing `.claude/worktrees/<ticket>`.
# The prompt is `prompts/<mode>.md` of this skill, with `{{TICKET}}`, `{{PR}}`
# and `{{REPORT}}` replaced.
#
# The session writes its report to `.ticket-report.md` at the root of its
# worktree, because Claude Code confines the session's writes to that
# worktree. The entry create-worktree.sh adds to the repository's
# `info/exclude` keeps the report out of commits. A report of an earlier run
# is removed before the launch.
#
# - `fix`: review fix of PR <pr>; Sonnet at medium effort; the session
#   commits, pushes and swaps the PR labels. Allow rules scoped to the
#   ticket branch and the PR approve those commands, so the auto mode
#   classifier cannot stop the handback.
# - `new`: greenfield work on the ticket; Opus at xhigh effort. Ask rules
#   make every `git commit` and `git push` wait for the developer's approval
#   in a permission prompt, also in auto mode.
#
# On success prints `session <id> <ticket> <mode>`, where <id> is the short id
# `claude attach`, `claude logs` and `claude stop` take. On a refused case
# prints one line with the reason to stderr and exits non-zero.
set -euo pipefail

die() {
  echo "launch-session: $*" >&2
  exit 1
}

[ "$#" -ge 2 ] && [ "$#" -le 3 ] ||
  die "usage: launch-session.sh <ticket> <fix|new> [<pr>]"
ticket=$1
mode=$2
pr=${3:-}
[[ $ticket =~ ^T[0-9]+$ ]] || die "ticket '$ticket' does not match T<number>"
case $mode in
  fix) [[ $pr =~ ^[0-9]+$ ]] || die "mode fix needs a PR number" ;;
  new) [ -z "$pr" ] || die "mode new takes no PR number" ;;
  *) die "mode '$mode' is not fix or new" ;;
esac

skill_dir=$(cd "$(dirname "$0")/.." && pwd)
common_dir=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null) ||
  die "not inside a git repository"
main=$(dirname "$common_dir")
cd "$main"
[ -d ".claude/worktrees/$ticket" ] ||
  die "$ticket: .claude/worktrees/$ticket does not exist; run create-worktree.sh"

prompt=$(<"$skill_dir/prompts/$mode.md")
prompt=${prompt//\{\{TICKET\}\}/$ticket}
report="$main/.claude/worktrees/$ticket/.ticket-report.md"
prompt=${prompt//\{\{PR\}\}/$pr}
prompt=${prompt//\{\{REPORT\}\}/$report}
rm -f "$report"

args=(--bg --worktree "$ticket" --name "$ticket")
if [ "$mode" = fix ]; then
  args+=(--model sonnet --effort medium
    --allowedTools "Bash(git add:*)" "Bash(git commit:*)"
    "Bash(git push origin $ticket)" "Bash(gh pr edit $pr *)")
else
  args+=(--model opus --effort xhigh --settings
    "{\"permissions\":{\"ask\":[\"Bash(git commit:*)\",\"Bash(git push:*)\"]}}")
fi

# `--allowedTools` takes a variable number of values; `--` ends them so the
# prompt is not read as a tool name.
output=$(claude "${args[@]}" -- "$prompt" 2>&1) ||
  die "$ticket: claude --bg failed: $(tail -n 1 <<<"$output")"

# `claude --bg` prints `backgrounded · <id> · <name>`.
id=$(sed -n 's/^backgrounded · \([0-9a-f]*\) · .*/\1/p' <<<"$output")
[ -n "$id" ] || die "$ticket: no session id in claude --bg output: $output"

echo "session $id $ticket $mode"
