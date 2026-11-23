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

- **Skill bodies.** Work out the placeholder skills fix-vulnerability and
  draft-advisory.
- **Release skill.** Guide the coordinated release: apply each merge request
  diff to the canonical repository with a neutral commit message, tag, and
  create the unpublished "Security update" release node.

## matrix (new plugin)

- **Messages through Matrix.** A plugin with a general skill that lets a session
  send a Matrix message to a contact and read the replies, with the CLI
  `matrix-commander-rs` (`8go/matrix-commander-rs`, on `matrix-sdk`) run through
  Bash, not an MCP server: `--message TEXT --room ROOM` sends,
  `--listen tail --tail N` reads; `--room` takes room IDs and aliases. A local
  contact file on each machine maps each contact, such as "me" or a family
  member, to a room alias; the repository holds no private details. The CLI logs
  in as a bot account of its own, not as the developer's account, with one
  `--login` per machine (a device and token per machine); the bot's rooms are
  unencrypted. A session sends only when asked; no hook. The README documents
  the permission rules: `Bash(matrix-commander-rs *)` in `allow` and an `ask`
  rule `Bash(matrix-commander-rs * <room> *)` per room of another person, so
  every message to them waits for confirmation (an `ask` rule wins over a
  matching `allow`). Installation from the AUR package `matrix-commander-rs-bin`
  0.10.2, which has token login, sending and `--listen tail` (upstream is at
  0.13.0); flagged out of date on 2026-11-16. If not updated by 2026-12-14, ask
  to co-maintain it or submit a source package `matrix-commander-rs`.

## drupal-contrib

- **CI failure summary.** Give a script or an `issue-development` step that
  lists the failed jobs of a merge request's pipeline on git.drupalcode.org and
  extracts the PHPStan errors and PHPUnit failures from each job's trace,
  without the ANSI colour codes.
