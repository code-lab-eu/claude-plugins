# Rule: self-improvement loop

Run this every session. It captures what was learned while working, then turns
those notes into concrete improvements to the project, rules, and skills.

## 1. At session start — open a session note

Create `docs/notes/{session-slug}.md` where `{session-slug}` is
`{YYYY-MM-DD}-{short-kebab-topic}` (date first for ordering, then a few words
naming the session's main task — e.g. `2026-06-08-self-improvement-rule`).

If the topic is unclear at the start, use a placeholder and rename the file once
it is. Seed the file with the template at the bottom of this rule.

These notes are **ephemeral**: `docs/notes/` is excluded from version control
and the developer purges it regularly. If `git check-ignore docs/notes` reports
that the directory is not ignored, add `docs/notes/` to `.git/info/exclude`; do
not edit `.gitignore` for this: that file is tracked and shared with the whole
team, and the session note is a personal practice. Treat a note as scratch
input for the loop, never as a source of truth. **Never link to or cite a
session note from durable documentation** (guides, ADRs, READMEs, skills,
rules, code comments) — anything worth keeping must be promoted into its proper
home when the loop closes (§4).

## 2. During the session — record noteworthy facts

Append to the note whenever any of the following occurs. Be specific (quote the
exact command, file, error, or wording); a finding a future session can act on
beats a vague summary.

Keep entries concise and evidence-based. Do not record private internal
deliberation or reconstruct unspoken intermediate thoughts.

- **Lessons learned** — anything now understood that wasn't before.
- **Developer corrections** — what the developer pushed back on, and the rule
  it implies. Cross-check existing memory and rules; flag conflicts.
- **Non-trivial discovery** — the finding, its supporting file or source, and
  any commands or results needed to reproduce or verify it.
- **Skill gaps** — a task that should have a skill/rule but doesn't.
- **Repeated attempts** — anything that took several tries to get right, and why.
- **Inconsistencies & conflicts** — contradictions between docs, rules, memory,
  code, or developer instructions.
- **Automatable repetition** — actions repeated often enough to become a skill,
  hook, or script.
- **Knowledge gaps** — missing information or insight that slowed the work.
- **Project-useful facts** — anything helpful for the project, or for evolving
  the agent rules and skills.

## 3. When to update the note

- **After every interaction with the developer.**
- **At the end of every agent action, before reporting back to the developer.**

**Practically:** update the note *before composing your reply*, not after. The
failure mode is treating the update as an afterthought and skipping it when the
exchange feels minor or the answer feels pressing. Neither is a reason to skip.
This has been a recurring failure across multiple sessions.

If an action produced nothing noteworthy, the note may stay unchanged — do not
pad it.

Session notes capture observable work history: developer feedback, actions
taken, results, decisions, and follow-up improvements. Keep durable
documentation focused on the design, constraints, and maintenance guidance
relevant to its readers.

Plan mode does not exempt you from this. Write the note update as usual: the
write is initiated by the agent and the developer is shown a confirmation
dialog. Do not skip or defer the update because plan mode is active.

## 4. Closing the loop

When the developer says to **end** or **wrap up** the session, or asks to **run
the self-improvement loop**, invoke the `self-improvement-loop:close` skill and
follow it.

## Session note template

```markdown
# Session notes — {session-slug}

**Date:** {YYYY-MM-DD}
**Topic:** {one line}

## Lessons learned

## Developer corrections

## Non-trivial discovery

## Skill gaps

## Repeated attempts / struggles

## Inconsistencies & conflicts

## Automatable repetition

## Knowledge gaps

## Project / agent-improvement facts

## Actionable findings (filled at loop close)

- [ ] {finding} → {improvement to apply}
```
