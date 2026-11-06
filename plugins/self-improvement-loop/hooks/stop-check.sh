#!/usr/bin/env bash
# Only ask Claude to update the note if it wasn't updated during this turn.
set -euo pipefail
input=$(cat)
[ "$(jq -r '.stop_hook_active' <<<"$input")" = true ] && exit 0
id=$(jq -r '.session_id // empty' <<<"$input" | tr -cd 'A-Za-z0-9_-')
marker="${TMPDIR:-/tmp}/claude-self-improvement-loop/$id"
notes="${CLAUDE_PROJECT_DIR:-$(jq -r '.cwd // "."' <<<"$input")}/docs/notes"
if [ -n "$id" ] && [ -f "$marker" ] && [ -d "$notes" ] \
  && [ -n "$(find "$notes" -name '*.md' -newer "$marker" | head -n 1)" ]; then
  exit 0
fi
jq -n '{decision: "block", reason: "Before stopping, update the active docs/notes/<session-slug>.md note per the self-improvement loop rule with anything noteworthy from this turn (developer corrections, non-trivial discoveries, struggles, skill gaps, inconsistencies). If genuinely nothing was noteworthy, stop again and leave the note unchanged. Reply with exactly \"Session notes updated.\" when the note was updated, or else with the reason it was not, in at most 8 words."}'
