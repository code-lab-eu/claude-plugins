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
  worker claims, and the premise of each requirement and each rejected
  alternative: that the case it addresses occurs, shown by the code (callers,
  call counts) or a probe.
- Check that a precedent is the prevailing convention. A form listed in a
  loaded skill's reference of counted forms, such as drupal-upstream-code's
  `core-forms.md`, is not recounted and is not a finding, unless the reference
  code base's version is higher than the entry's: then recount it with the
  entry's command and scope. For any other form, count the competing forms in
  the reference code base with `rg`, and require the majority form unless the
  plan or a concrete reason requires another. One precedent is not enough. A
  count that differs from the worker's but gives the same majority is not a
  finding; a count whose scope includes lines that do something else,
  deprecated lines or test code is.
- Check that the tests cover every behaviour of the phase.
- Run the phase's verification commands yourself.
- When every background command you started has finished or is stopped,
  return `APPROVED`, or a numbered list of findings, each with file, line, the
  rule or precedent with its count, and the required change. Report every
  finding in one pass. Only findings backed by a rule, a precedent, the plan,
  or a fact shown by the code or a probe; no preferences.
- The points under "Settled" in the phase file are not findings, unless you
  have a new fact.

## Tooling (not findings)

<Quirks of the project's commands that are not defects.>
