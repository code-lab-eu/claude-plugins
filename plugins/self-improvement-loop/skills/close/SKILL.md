---
name: close
description: Close the self-improvement loop by promoting findings from the session note into durable project rules, skills, and docs. Use when the developer says to end or wrap up the session, or asks to run the self-improvement loop.
---

# Closing the self-improvement loop

1. **Review** the full session note in `docs/notes/`.
2. **Identify actionable findings** — only those that yield a tangible
   improvement to future work: new or updated skills, rules, docs, scripts,
   automations, or memory.
3. **Auto-apply every finding immediately** — make the edits/additions in this
   session.
4. **Then ask the developer to review** the applied changes, **before
   committing**. List what changed and why, so the review is quick.

Findings that are not actionable (one-offs, already-covered ground) produce no
change. Because the note is ephemeral, anything that must survive the next purge
has to be promoted out of the note in step 3 — don't rely on the note itself to
preserve it.

## Where promoted knowledge lives

Durable knowledge goes into **version-controlled repo homes**, so it is available
on every machine and to every contributor. Use the homes the project already
has; determine them from `CLAUDE.md`, `AGENTS.md`, and the existing directory
layout rather than introducing a new layout. Projects have up to three kinds:

- **Rules** — agent conventions and working practices that are always in
  context (for example `CLAUDE.md`, `AGENTS.md`, or rule files imported by
  them). Content that applies broadly, with no single discrete trigger, belongs
  here.
- **Skills** — procedures keyed to a discrete, nameable agent action (creating
  a commit, working on CI/deploy). Prefer a skill over a rule whenever the
  content only matters at one identifiable point in a session — it avoids
  paying context on every turn for a concern that applies rarely. The harness
  only discovers project skills under `.claude/skills/` (directly or through a
  symlink); verify a new skill is reachable from there before trusting it to be
  found.
- **Docs** — project facts and decisions (guides, ADRs).

If the project has no home of the required kind, ask the developer where the
finding should go instead of choosing a location.

Committing is gated on value, not on location: these homes are version
controlled, and content that is worth sharing gets committed. Trivial or
still-maturing content may sit uncommitted (locally excluded) until it is.

Do **not** rely on the agent's local memory as a durable home: it is per-machine
and not version-controlled, so it is invisible on other developers' machines.
When a finding currently lives only in local memory, promote it into one of the
homes above.

**Memory and repo are complementary, not either/or.** The repo is the
authoritative home; local memory is a per-session pointer that summarises what
lives in the repo. A memory entry for a project fact should contain a reference
to the repo file, not the fact itself.

A practical check at loop close: for every memory entry written or updated this
session, ask "does the underlying fact also exist in the repo?" If not, add it
there first, then reduce the memory entry to a pointer.
