# Merge request review

The plan selects this mode with an entry in its shared sections:

```text
Review: merge request against <target branch>[, push after phases <n>, <m>]
```

The run pushes the plan's branch after every committed phase, or after the
listed phases and the last one, so that CI runs on each push, and opens a draft
merge request against the target branch. The developer reviews the merge request
after the run.

The entry instructs these actions and no others: a fast-forward push of the
plan's branch to `origin`, creating the draft merge request, and a decision
thread on it for each decision the run records. Every other outward-facing
action waits for the developer, as `SKILL.md` says, among them a force push,
marking the merge request ready, merging, and any other comment. A fix goes into
a new commit.

## Each push

1. On GitLab, once the merge request exists, record its head pipeline id:
   `glab api projects/:id/merge_requests/<iid> | jq .head_pipeline.id`.
2. `git push origin <branch>`, with `-u` the first time.
3. After the first push, create the merge request, with the plan's title and a
   description of its goal and phases in `<scratchpad>/briefs/mr.md`:

   ```sh
   glab mr create --source-branch <branch> --target-branch <target> \
     --title '<title>' --description-file <scratchpad>/briefs/mr.md \
     --draft --push=false --yes
   gh pr create --base <target> --head <branch> --title '<title>' \
     --body-file <scratchpad>/briefs/mr.md --draft
   ```

4. Wait for the pipeline of the pushed commit in a background command, which
   notifies on exit. On GitLab:

   ```sh
   until glab api projects/:id/merge_requests/<iid> | jq -e \
     --arg sha "$(git rev-parse HEAD)" --argjson old <recorded id or null> \
     '.sha == $sha and .head_pipeline.id != $old
      and (.head_pipeline.status | IN("success", "failed", "canceled"))'
   do sleep 60; done
   ```

   Right after the push, `head_pipeline` can still be the previous pipeline, and
   a merged results pipeline runs on the merge of the branch into the target, so
   its own `sha` is not the pushed commit; hence the merge request's `sha` and
   the changed id. On GitHub, wait until
   `gh run list --commit <sha> --json databaseId` lists the runs, then
   `gh run watch <id> --exit-status` for each.
5. Green: start the next phase. Red: run a pipeline round.

## Pipeline round

A red pipeline is a finding of the phases pushed with it, handled before the
next phase starts:

1. Collect each failed job's name and the failing checks with their messages,
   without ANSI colour codes, into the next worker's scratchpad. On GitLab, list
   the jobs with
   `glab api 'projects/:id/pipelines/<pipeline id>/jobs?scope[]=failed'` and
   read each with `glab ci trace <job id>`; on GitHub,
   `gh run view <id> --log-failed`.
2. Handle them as review findings, by steps 3, 2 and 4 of "Run each phase": a
   new worker, fresh reviewers until one approves, and a new commit. Then push
   and wait again.

The worker rejects a failure the branch does not cause, with its evidence: the
same job fails on the target branch's latest pipeline, or the job log shows an
infrastructure error. Retry the failed jobs once (`glab ci retry <job id>`,
`gh run rerun <id> --failed`). When they fail again, record the failure as a
decision, list it in the report as waiting for the developer, and start the next
phase.

## Decision threads

Each decision the run records, by the orchestrator or a worker, also goes on the
merge request as a thread of its own, posted when it is recorded; the developer
resolves each thread in review. Decisions recorded before the first push are
posted right after the merge request is created.

Write the body to `<scratchpad>/briefs/decision-<n>.md`: a first line that marks
it as a decision of the plan-execution run, since the comment appears under the
developer's account, then the phase, the decision, and its reason.

```sh
glab api projects/:id/merge_requests/<iid>/discussions \
  --field body=@<scratchpad>/briefs/decision-<n>.md
gh pr comment <number> --body-file <scratchpad>/briefs/decision-<n>.md
```

On GitHub, a pull request comment cannot be resolved.
