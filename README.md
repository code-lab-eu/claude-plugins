# Code Lab Claude Code plugins

Claude Code plugin marketplace for Code Lab.

## Installation

Per developer, for all projects:

```
claude plugin marketplace add https://github.com/code-lab-eu/claude-plugins.git
claude plugin install drupal-contrib@code-lab
claude plugin install drupal-security@code-lab
claude plugin install grilling@code-lab
claude plugin install plan-execution@code-lab
claude plugin install self-improvement-loop@code-lab
claude plugin install ticket-worktrees@code-lab
claude plugin install writing-for-agents@code-lab
```

Per project, for every contributor, in the committed `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "code-lab": {
      "source": {
        "source": "git",
        "url": "https://github.com/code-lab-eu/claude-plugins.git"
      }
    }
  },
  "enabledPlugins": {
    "self-improvement-loop@code-lab": true
  }
}
```

Per project, for one developer only. Use this in customer repositories, where
our plugins must not appear in the committed configuration. Either run this in
the repository:

```
claude plugin install self-improvement-loop@code-lab --scope local
```

or add the `enabledPlugins` entry shown above to `.claude/settings.local.json`.
The marketplace must already be registered with `claude plugin marketplace add`.
Check that the file is not tracked before relying on it:

```
git check-ignore .claude/settings.local.json || echo '.claude/settings.local.json' >> .git/info/exclude
```

Do not add the file to the customer's `.gitignore`.

## Updating

Installed plugins update from the pushed repository, and only when a plugin's
`version` changes. Restart Claude Code afterwards:

```
claude plugin marketplace update code-lab
claude plugin update <plugin>@code-lab --scope <user|project|local>
```

## Plugins

### self-improvement-loop

Records what was learned during a session in an ephemeral note under
`docs/notes/`, and promotes the actionable findings into the project's rules,
skills, and docs when the session ends.

| Component | Purpose |
|---|---|
| `SessionStart` hook | Loads the self-improvement-loop rule into the context. |
| `UserPromptSubmit` hook | Reminds Claude to update the session note. |
| `Stop` hook | Holds back a turn that did not update the session note. |
| `self-improvement-loop:close` skill | Promotes the session note's findings into the project. |

Session notes are per developer and are never committed. The rule adds
`docs/notes/` to `.git/info/exclude` when the directory is not already ignored.

Requires `jq`.

### drupal-contrib

Local development of Drupal contrib modules and themes. Nothing it sets up is
committed to the project's repository, and code is written in the form Drupal
core uses.

| Component | Purpose |
|---|---|
| `drupal-contrib:ddev-drupal-contrib` skill | Sets up a local DDEV site for a contrib checkout. |
| `drupal-contrib:install-site` skill | Installs Drupal on the local site. |
| `drupal-contrib:drupal-upstream-code` skill | Writes code in the form Drupal core uses. |
| `drupal-contrib:issue-queue` skill | Manages a project's issues on git.drupalcode.org. |
| `drupal-contrib:issue-development` skill | Develops a change for a drupal.org issue in its issue fork. |
| `drupal-contrib:issue-review` skill | Reviews the merge request of a drupal.org issue. |
| `drupal-contrib:wait-pipeline` skill | Waits for a merge request's pipeline after a push. |

Requires DDEV, and `glab` for the issue skills.

### grilling

Grills the developer about a plan until both share an understanding of it. Each
message asks one question, with options, pros and cons, best practice, and a
recommendation. Nothing is acted on before the developer confirms the shared
understanding.

| Component | Purpose |
|---|---|
| `SessionStart` hook | Loads the decision format rule into the context. |
| `grilling:grilling` skill | Interviews the developer about a plan. |
| `grilling:grill-me` skill | Starts a grilling session on the developer's request. |

Adapted from the MIT-licensed skills of Matt Pocock; see
`plugins/grilling/LICENSE`.

### drupal-security

Helps maintainers resolve vulnerabilities in their drupal.org contrib projects
that the [Drupal Security Team](https://www.drupal.org/drupal-security-team)
manages in confidential work items on git.drupalcode.org. Drupal core is not
covered. fix-vulnerability and draft-advisory are placeholders still to be
worked out.

| Component | Purpose |
|---|---|
| `drupal-security:file-report` skill | Files a new confidential vulnerability report. |
| `drupal-security:validate-report` skill | Validates a vulnerability report. |
| `drupal-security:fix-vulnerability` skill | Fixes a validated vulnerability. |
| `drupal-security:review-fix` skill | Reviews the fix of a vulnerability. |
| `drupal-security:draft-advisory` skill | Drafts the security advisory. |
| `drupal-security:move-to-public` skill | Moves a report that gets no advisory to the public issue queue. |
| `reference/workflow.md` | The security issue process. |
| `reference/risk-levels.md` | The risk scoring reference. |

Requires `glab` authenticated for git.drupalcode.org. Works best with the
drupal-contrib plugin installed: the skills use its local site and code skills
when they are present. With the chrome-devtools-mcp plugin installed,
`draft-advisory` offers to fill the advisory form in the browser.

### ticket-worktrees

Runs one background Claude Code session per ticket, each in its own git worktree
under `.claude/worktrees/<ticket>` on branch `<ticket>`. Open PRs labelled
`gilfoyle:changes-requested` get a review session that commits, pushes, and
requests a new review; tickets the developer names get a greenfield session that
leaves its changes uncommitted, and commits or pushes only on the developer's
instruction and approval.

| Component | Purpose |
|---|---|
| `ticket-worktrees:orchestrate` skill | Runs the ticket sessions and reports their results. |
| `scripts/create-worktree.sh` | Prepares a ticket's worktree. |
| `scripts/launch-session.sh` | Starts a ticket session. |
| `scripts/poll-sessions.sh` | Watches the ticket sessions. |
| `scripts/prune-worktrees.sh` | Removes the worktrees of merged tickets. |
| `prompts/fix.md`, `prompts/new.md` | The ticket session prompts. |

Each repository adds `/.claude/worktrees/` to its `.gitignore`, and may provide
an executable `scripts/worktree-setup.sh <main-checkout>` that prepares the
worktree in its working directory, such as a virtualenv and local settings. The
main checkout's copy runs, so branches without the script are set up too. Start
the orchestrator session with `claude --model sonnet --effort low`.

Requires `gh` authenticated for the repository, `jq`, and the Phorge Conduit MCP
server for greenfield tickets.

### writing-for-agents

Reference for writing documents an agent consumes: skills, `AGENTS.md`, and
`CLAUDE.md`.

| Component | Purpose |
|---|---|
| `writing-for-agents:writing-for-agents` skill | Guidance for writing documents an agent consumes. |

Adapted from the MIT-licensed skills of Matt Pocock; see
`plugins/writing-for-agents/LICENSE`.

### plan-execution

Executes the phases of a plan unattended. The session is the orchestrator: per
phase it starts a worker sub-agent, fresh reviewer sub-agents until one
approves, and a fresh agent that commits the phase. A decision that would go to
the developer is taken on precedent or best practice and listed in the final
report. The plan and the skills it names carry the rules of the stack.

| Component | Purpose |
|---|---|
| `plan-execution:orchestrate` skill | Executes the phases of a plan. |
| `briefs/worker-common.md`, `briefs/reviewer-common.md` | Templates for the sub-agent briefs. |

With the self-improvement-loop plugin installed, the decisions are recorded in
its session note.
