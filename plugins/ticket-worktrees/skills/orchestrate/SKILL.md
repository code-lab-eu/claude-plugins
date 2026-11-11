---
name: orchestrate
description: Starts one background Claude Code session per ticket, each in its own git worktree, watches them until they finish, and removes merged worktrees. Review fixes come from open PRs labelled gilfoyle:changes-requested; greenfield tickets are named in the arguments.
disable-model-invocation: true
argument-hint: "[new T1234 ...]"
allowed-tools: Bash(${CLAUDE_SKILL_DIR}/scripts/prune-worktrees.sh) Bash(${CLAUDE_SKILL_DIR}/scripts/create-worktree.sh *) Bash(${CLAUDE_SKILL_DIR}/scripts/launch-session.sh *) Bash(${CLAUDE_SKILL_DIR}/scripts/poll-sessions.sh *) Bash(gh pr list *) Bash(gh pr view *) Bash(claude logs *)
---

# Orchestrate ticket sessions

This session is the orchestrator; it starts one background session per
ticket, in the ticket's worktree. Run every command from the main checkout of
the repository. Each script exits non-zero with a one-line reason when it
refuses; report that reason to the developer and go on with the next ticket.
Do not change code yourself; the ticket sessions do.

Arguments: `$ARGUMENTS`

## 1. Remove merged worktrees

Run `${CLAUDE_SKILL_DIR}/scripts/prune-worktrees.sh`. Report the `removed`
lines in one sentence; mention a `kept` line only when its reason is not "not
merged into origin/master" or "uncommitted changes".

## 2. Collect the tickets

Review fixes: run

```
gh pr list --state open --label gilfoyle:changes-requested --json number,headRefName,headRefOid
```

Each PR whose `headRefName` matches `T[0-9]+` is a ticket in mode `fix`, with
its PR number and head commit. Name the skipped PRs to the developer.

Greenfield: each `T[0-9]+` in the arguments after `new` is a ticket in mode
`new`. Skip one that is also a review fix, and say so.

With no tickets, report that and stop.

## 3. Start a session per ticket

For each ticket, run

```
${CLAUDE_SKILL_DIR}/scripts/create-worktree.sh <ticket> <fix|new>
${CLAUDE_SKILL_DIR}/scripts/launch-session.sh <ticket> fix <pr>
${CLAUDE_SKILL_DIR}/scripts/launch-session.sh <ticket> new
```

`create-worktree.sh` first, then `launch-session.sh` only when it succeeded.
`launch-session.sh` prints `session <id> <ticket> <mode>`. Keep a table of
session id, ticket, mode, PR number and head commit, and show it to the
developer.

## 4. Watch the ticket sessions

Start the Monitor tool on

```
${CLAUDE_SKILL_DIR}/scripts/poll-sessions.sh <id> <id> ...
```

with a timeout of 30 minutes. It prints `<id> <name> <state>` for each
change to `blocked`, `done`, `failed` or `stopped`, and `<id> - missing` for a
session that disappeared. When the Monitor expires, start it again with only
the ids that have not reached `done`, `failed`, `stopped` or `missing`.

## 5. Handle each event

- `done`: read the session's report with `claude logs <id>`. For a review fix,
  run `gh pr view <pr> --json headRefOid,labels` and confirm that the head
  commit differs from the one in the table and that the labels include
  `gilfoyle:review-requested`. Report the result, and any check that failed,
  to the developer. For a greenfield ticket, report the summary and the
  proposed commit message. The developer commits, either by telling the
  session to (`claude attach <id>`; each commit and push asks the developer
  for approval) or in `.claude/worktrees/<ticket>`.
- `blocked`: tell the developer the session waits for them:
  `claude attach <id>`.
- `failed`, `stopped` or `missing`: report it with the end of
  `claude logs <id>`.

The work is done when every ticket session has reached `done`, `failed`,
`stopped` or `missing` and each one is reported.
