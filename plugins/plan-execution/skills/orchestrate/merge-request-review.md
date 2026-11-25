# Merge request review

The plan selects this mode with an entry in its shared sections:

```text
Review: merge request against <target branch>[, push after phases <n>, <m>]
```

The run pushes the plan's branch so that CI runs on its phases, and opens a
draft merge request against the target branch. A push is due after every
committed phase, or after the listed phases and the last one. While a pipeline
runs, the run goes on: it implements, reviews and commits the next phases, but
pushes none of them until the pipeline is green. The run reports when the
pipeline of the last phase has ended. The developer reviews the merge request
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
2. Push the commit of the last due phase by its SHA:
   `git push origin <sha>:refs/heads/<branch>`. Pushing `<branch>` would also
   push a phase committed after it while the push retries.
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
   notifies on exit, and go on with the next phase meanwhile. On GitLab:

   ```sh
   until glab api projects/:id/merge_requests/<iid> | jq -e \
     --arg sha <pushed sha> --argjson old <recorded id or null> \
     '.sha == $sha and .head_pipeline.id != $old
      and (.head_pipeline.status | IN("success", "failed", "canceled"))'
   do sleep 60; done
   ```

   Right after the push, `head_pipeline` can still be the previous pipeline, and
   a merged results pipeline runs on the merge of the branch into the target, so
   its own `sha` is not the pushed commit; hence the merge request's `sha` and
   the changed id. The comparison is with the pushed SHA, not with `HEAD`,
   because a phase can be committed during the wait. On GitHub, wait until
   `gh run list --commit <pushed sha> --json databaseId` lists the runs, then
   `gh run watch <id> --exit-status` for each.
5. Green: push the last due phase committed since this push; when there is none,
   push the next due phase as soon as it is committed. Red: run a pipeline
   round.

## Pipeline round

A red pipeline is a finding of the phases pushed with it. Its fix goes on top of
the pushed commit, so that the phases committed since then reach CI after the
fix:

1. Collect each failed job's name and the failing checks with their messages,
   without ANSI colour codes, into the next worker's scratchpad. On GitLab, list
   the jobs with
   `glab api 'projects/:id/pipelines/<pipeline id>/jobs?scope[]=failed'` and
   read each with `glab ci trace <job id>`; on GitHub,
   `gh run view <id> --log-failed`.
2. Let the phase in progress run until its commit, start no other, and switch to
   the pushed commit: `git switch --detach <pushed sha>`.
3. Handle the failures as review findings, by steps 3, 2 and 4 of "Run each
   phase": a new worker, fresh reviewers until one approves, and a new commit.
   Push the fix by its SHA, `git push origin <fix sha>:refs/heads/<branch>`, and
   wait for its pipeline. Red again: another pipeline round, on top of the fix.
4. Green: rebase the phases committed since the pushed commit onto the fix,
   which also switches back to the branch:
   `git rebase --onto <fix sha> <pushed sha> <branch>`. On a conflict in a
   generated file, such as a lock file, take the fix's version with
   `git checkout --ours <file>` (in a rebase, `--ours` is the side being rebased
   onto), rerun the commands of the replayed phase that generate the file,
   `git add` it and `git rebase --continue`. A conflict in any other file is a
   finding of the replayed phase: a worker resolves it and a reviewer approves
   it, by steps 3 and 2 of "Run each phase", before `git rebase --continue`.
   Then go on as on a green pipeline.

The worker rejects a failure the branch does not cause, with its evidence: the
same job fails on the target branch's latest pipeline, or the job log shows an
infrastructure error. Retry the failed jobs once (`glab ci retry <job id>`,
`gh run rerun <id> --failed`). When they fail again, record the failure as a
decision and list it in the report as waiting for the developer. Whether the
retry passes or not, switch back with `git switch <branch>` and go on as on a
green pipeline.

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
