#!/usr/bin/env bash
# Remember when the turn started, so stop-check.sh can see if the note was
# updated during this turn.
set -euo pipefail
input=$(cat)
id=$(jq -r '.session_id // empty' <<<"$input" | tr -cd 'A-Za-z0-9_-')
if [ -z "$id" ]; then
  echo "self-improvement-loop: no session_id in the hook input" >&2
  exit 1
fi
# Keep the markers in a temp directory so they stay out of the project.
# Each session gets its own file, so parallel sessions don't mix up their turns.
dir="${TMPDIR:-/tmp}/claude-self-improvement-loop"
mkdir -p "$dir"
touch "$dir/$id"
echo "Self-improvement loop: update docs/notes/<session-slug>.md before you reply."
