---
name: orchestrate
description: Executes the phases of a plan unattended. Per phase, a worker sub-agent implements it, fresh reviewer sub-agents review it until one approves, and a fresh agent commits it; the decisions taken are listed at the end.
disable-model-invocation: true
argument-hint: "<plan file> [phases]"
---

# Execute a plan unattended

This session is the orchestrator. It runs the phases of the plan named in
`$ARGUMENTS` with sub-agents, writes no project code itself, and reports to the
developer when every phase is committed. The plan settles what is built and how
it is checked; the rules of the stack come from the plan and the skills it
names. Where the plan's own execution model differs from this skill on
sub-agents, commits or decisions, this skill applies.

Before the run, check that the plan gives each phase its scope and verification
commands, and gives the branch and the commit message form: committing each
approved phase in that form is the developer's instruction for this run. The
plan's `Review:` entry selects the review mode: without one, the run pushes
nothing and the developer reviews the branch locally; with
`Review: merge request`, follow `${CLAUDE_SKILL_DIR}/merge-request-review.md` as
well. Ask the developer for what is missing; from then on, the run does not stop
for them.

## Decisions

A decision that the plan, a rule or a skill says to put to the developer is
taken by the orchestrator instead: the option with a precedent, or else the best
practice. Record it with its reason in the session note under `docs/notes/`, or
in `<scratchpad>/briefs/decisions.md` when the session keeps none, and go on.
Workers decide in the same way and list their decisions in the handover; record
those too.

Hard-to-reverse and outward-facing actions, such as a push, a release, deleting
data or a message to anyone, are not decisions the run takes: they wait for the
developer, and the run goes on with the work that does not depend on them. The
one exception is the pushes and the merge request that merge request review
instructs.

## 1. Write the briefs

Create `<scratchpad>/briefs/` with:

- `preamble.md`: the plan's shared sections (rules, references, execution
  model), copied verbatim with `sed -n '<first>,<last>p'`.
- `phase-<n>.md`: each phase, copied verbatim the same way.
- `worker-common.md` and `reviewer-common.md`: copies of the templates in
  `${CLAUDE_SKILL_DIR}/briefs/`, with the project's facts filled in.

The briefs are the run's working copy of the plan; corrections and settled
points go into them. A sub-agent prompt is then a few lines: the brief files to
read, the phase and round, the findings in a findings round, and the sub-agent's
own scratchpad directory,
`<scratchpad>/phase-<n>-<worker|review|commit>-<round>/`.

## 2. Check the verification commands

Run every phase's verification commands once. Commands written before the code
exists often cannot pass as written: an option a tool rejects, a check that
fails while there is nothing to check yet, a test command that runs every test
twice. For each failure, tell whether the phase's missing work causes it or the
command itself. Correct each command of the second kind in its phase file, add
the quirk under "Tooling" in both common briefs, and record the correction as a
decision.

## 3. Run each phase

Start a fresh sub-agent for each round and each commit, with the model and
effort the phase names; when it names none, choose them for the work and record
the choice as a decision. Never resume a finished sub-agent with SendMessage: it
brings back its whole context, and a resumed agent's commit was blocked twice.

1. A worker implements the phase per `worker-common.md` and hands over.
2. A reviewer reviews it per `reviewer-common.md` and returns `APPROVED` or
   numbered findings.
3. On findings, a new worker gets them verbatim with the orchestrator's notes
   (below) and hands over; go back to step 2.
4. On `APPROVED`, a commit agent (sonnet, low effort) stages the phase's files,
   checks with `git status` that nothing of the phase is left unstaged and
   nothing else is staged, and commits in the plan's message form with plain
   `git commit -m '<summary>' -m '<body>'`.
5. In merge request review, push and wait for the pipeline; a red pipeline
   starts a pipeline round of the phase.
6. Start the next phase.

After each review, before the next sub-agent starts:

- Add each class of defect the reviewer found, with its rule or counted
  convention, to "What reviewers rejected" in `worker-common.md`.
- When a finding reverses an earlier round, a brief or the plan, name the
  instruction it overrides in the next prompt, and add the outcome to the phase
  file under "Settled".
- When a class of defect recurs, have the next worker sweep the whole class
  across the phase's work at once, such as a map of every documented claim to
  the test that covers it, instead of fixing the instance reported. Fixing one
  instance per round kept one phase in review for 13 rounds.

## 4. Report

When every phase is committed, report to the developer: the commits, the results
of the verification commands, in merge request review the merge request's URL
and the pipeline result of each push, each decision taken with its reason, and
the actions that wait for the developer.
