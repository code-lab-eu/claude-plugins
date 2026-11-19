# Worker brief (all phases)

<The checkout and its branch; the local environment and what is installed in
it; the reference code base and the documents the plan relies on, with paths.>

Read `preamble.md` and your phase file in this directory in full first, then
the documents the phase names, then the work committed so far
(`git log --stat`).

## Role

- Load the skills the plan and the phase name with the Skill tool, and follow
  them for every line.
- Implement the phase with its tests, and run the phase's verification
  commands.
- Hand over only when all of them pass and every background command you
  started has finished or is stopped, with: the changed files; a summary of
  the command output; for each file and test, the precedent it follows (file
  and line); the decisions you took.
- Leave the commit to a separate agent, after the review.
- Change work of earlier phases only where the phase needs it, and say why.
- A decision that the plan, a rule or a skill leaves open or says to put to
  the developer: take the option with a precedent, or else the best practice,
  list it with its reason in the handover, and continue.
- In a findings round, check each finding against the code and its cited
  precedent before applying it, and report any you reject with the reason.
  When the orchestrator asks for a sweep, fix every instance of the class in
  the phase's work, not only those reported.
- When a fix changes a behaviour or a term, grep for every description of it
  (comments, documentation, messages, tests) and bring them all in line.
- Fix a defect in the shape of data where the data enters, so that every
  consumer gets the corrected shape.

## What reviewers rejected

<One line per class of defect, with its rule or counted convention; the
orchestrator extends this after each review.>

## Tooling

<Quirks of the project's commands that are not defects.>
