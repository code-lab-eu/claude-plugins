#!/usr/bin/env bash
# Waits for the pipeline of a merge request on git.drupalcode.org to finish
# after a push, and prints its id, status, commit and URL.
#
# Usage: wait-pipeline.sh <project path> <iid> <pushed commit> [<previous pipeline id>]
#
# The project path is the full path of the project that holds the merge
# request, such as project/graphql_webform or
# security/3617853-graphql_core_schema-security.
#
# Run it in the checkout: the pushed commit is any revision git resolves there,
# such as HEAD, and a revision that names no commit fails at once.
#
# Right after a push, the head pipeline of the merge request can still be the
# previous one. The script waits until the commit of the merge request is the
# pushed one and its head pipeline is not the previous pipeline, then until that
# pipeline ends. It exits 0 when the pipeline succeeds, 1 when it ends in
# another status, and 2 when it does not end within an hour.
set -euo pipefail

project=${1:?project path}
project=${project//\//%2F}
iid=${2:?merge request iid}
commit=$(git rev-parse --verify "${3:?pushed commit}^{commit}")
previous=${4:-}

export GITLAB_HOST=git.drupalcode.org
deadline=$((SECONDS + 3600))
line='- - - -'

while ((SECONDS < deadline)); do
  if line=$(glab api "projects/${project}/merge_requests/${iid}" |
    python3 -I -c '
import json, sys
mr = json.load(sys.stdin)
pipeline = mr.get("head_pipeline") or {}
print(mr["sha"], pipeline.get("id", "-"), pipeline.get("status", "-"),
      pipeline.get("web_url", "-"))
'); then
    read -r sha id status url <<<"$line"
    if [[ $sha == "$commit" && $id != - && $id != "$previous" ]]; then
      case $status in
        created | waiting_for_resource | preparing | pending | running | scheduled) ;;
        *)
          echo "$id $status $sha $url"
          [[ $status == success ]]
          exit $?
          ;;
      esac
    fi
  fi
  sleep 30
done

echo "$line (timed out)"
exit 2
