#!/usr/bin/env bash
# Reports when ticket sessions finish or need the developer, for a Monitor.
#
# Usage: poll-sessions.sh <session-id>...
#
# Every 30 seconds (`POLL_INTERVAL` overrides) reads `claude agents --json
# --all` and prints `<id> <name> <state>` when a session's state changes to
# `blocked`, `done`, `failed` or `stopped`. A session that is missing from two
# reads in a row is reported once as `missing`. Exits when every session is
# `done`, `failed`, `stopped` or `missing`. A failed read is skipped and
# retried at the next interval.
set -uo pipefail

if [ "$#" -eq 0 ]; then
  echo "usage: poll-sessions.sh <session-id>..." >&2
  exit 1
fi
interval=${POLL_INTERVAL:-30}

declare -A state misses
for id in "$@"; do
  state[$id]=
  misses[$id]=0
done

is_terminal() {
  case $1 in done | failed | stopped | missing) return 0 ;; esac
  return 1
}

while :; do
  if listing=$(claude agents --json --all 2>/dev/null |
    jq -r '.[] | select(.kind == "background")
      | "\(.id) \(.state // "unknown") \(.name // "-")"'); then
    for id in "$@"; do
      is_terminal "${state[$id]}" && continue
      line=$(grep -m 1 "^$id " <<<"$listing")
      if [ -z "$line" ]; then
        misses[$id]=$((misses[$id] + 1))
        if [ "${misses[$id]}" -ge 2 ]; then
          state[$id]=missing
          echo "$id - missing"
        fi
        continue
      fi
      misses[$id]=0
      read -r _ new name <<<"$line"
      if [ "$new" != "${state[$id]}" ]; then
        state[$id]=$new
        case $new in
          blocked | done | failed | stopped) echo "$id $name $new" ;;
        esac
      fi
    done
  fi

  all_terminal=true
  for id in "$@"; do
    is_terminal "${state[$id]}" || all_terminal=false
  done
  $all_terminal && exit 0
  sleep "$interval"
done
