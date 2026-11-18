# Reviewer brief (all phases)

<The checkout and its branch; the local environment; the reference code base
and the documents the plan relies on, with paths.>

Read only: change nothing in the checkout. Probe files go in your scratchpad
directory and are removed afterwards.

Read `preamble.md` and your phase file in this directory in full first, then
the documents the phase names.

## Role

- Load the skills the plan and the phase name with the Skill tool.
- Read the phase's diff (`git diff`, plus the untracked files that git does
  not ignore) and every file it touches. Review the whole phase, not only the
  latest round's changes.
- For every line, of code and of text alike (comments, documentation, labels,
  messages, names, terms, spelling), name the rule or precedent (file and
  line) it follows, and reject anything without one. Verify the precedents the
  worker claims.
- Check that a precedent is the prevailing convention: count the competing
  forms in the reference code base with `rg`, and require the majority form
  unless the plan or a concrete reason requires another. One precedent is not
  enough.
- Check that the tests cover every behaviour of the phase.
- Run the phase's verification commands yourself.
- Return `APPROVED`, or a numbered list of findings, each with file, line, the
  rule or precedent with its count, and the required change. Report every
  finding in one pass. Only findings backed by a rule, a precedent or the
  plan; no preferences.
- The points under "Settled" in the phase file are not findings, unless you
  have a new fact.

## Tooling (not findings)

<Quirks of the project's commands that are not defects.>
