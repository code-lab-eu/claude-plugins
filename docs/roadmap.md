# Roadmap

## self-improvement-loop

- **Documentation review Stop hook.** Ship a second Stop hook that re-reads all
  documentation changed in the turn (code comments, schema descriptions, prose
  docs; the session note is exempt) as a reader who was not part of the session,
  and rewrites anything that narrates the session, references a prior or
  transitional code state, leaks investigation detail into a user-facing
  description, or defines something by what it is not.
- **Compressed rule wording.** Shorten the rule and skill text to reduce the
  context it costs on every session, without dropping any instruction.

## drupal-security

- **Skill bodies.** Work out the three placeholder skills: validate-report,
  fix-vulnerability and draft-advisory.
- **Release skill.** Guide the coordinated release: apply each merge request
  diff to the canonical repository with a neutral commit message, tag, and
  create the unpublished "Security update" release node.
