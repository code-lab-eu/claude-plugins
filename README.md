# Code Lab Claude Code plugins

Claude Code plugin marketplace for Code Lab.

## Installation

Per developer, for all projects:

```
/plugin marketplace add https://github.com/code-lab-eu/claude-plugins.git
/plugin install drupal-contrib@code-lab
/plugin install drupal-security@code-lab
/plugin install grilling@code-lab
/plugin install self-improvement-loop@code-lab
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
The marketplace must already be registered with `/plugin marketplace add`.
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
| `SessionStart` hook | Adds `rules/self-improvement-loop.md` to the context on startup, `/clear`, and compaction. |
| `UserPromptSubmit` hook | Marks the start of each turn and reminds Claude to update the session note before replying. |
| `Stop` hook | Blocks the first stop of a turn in which no note under `docs/notes/` changed, with a reminder to update it. |
| `self-improvement-loop:close` skill | Promotes findings from the note into durable homes. Triggered by "wrap up", "end the session", or "run the self-improvement loop". |

Session notes are per developer and are never committed. The rule adds
`docs/notes/` to `.git/info/exclude` when the directory is not already ignored.

Requires `jq`.

### drupal-contrib

Local development of Drupal contrib modules and themes. Nothing it sets up is
committed to the project's repository, and code is written in the form Drupal
core uses.

| Component | Purpose |
|---|---|
| `drupal-contrib:ddev-drupal-contrib` skill | Sets up a local DDEV site for a contrib checkout, such as a drupal.org issue fork, with the ddev-drupal-contrib add-on, and keeps its files out of git through `.git/info/exclude`. |
| `drupal-contrib:install-site` skill | Installs Drupal, Drush and the modules a task needs in a ddev-drupal-contrib setup. |
| `drupal-contrib:drupal-upstream-code` skill | Writes code for Drupal core or a contrib project in the form core uses: finds the core precedent for each construct, and lists the comment forms most often missed. |
| `drupal-contrib:issue-queue` skill | Searches a project's issue queue for an existing issue, drafts a new one in Drupal's issue summary template, files it as a git.drupalcode.org work item, and relabels it after the merge. Requires `glab`. |
| `drupal-contrib:issue-fork` skill | Iterates on a drupal.org issue in its public issue fork: reads the reviewers' remarks and pushes new commits on top of other contributors' work as a fast-forward. Requires `glab` and SSH push access to the fork. |

Requires DDEV.

### grilling

Grills the developer about a plan until both share an understanding of it. Each
message asks one question, with options, pros and cons, best practice, and a
recommendation. Nothing is acted on before the developer confirms the shared
understanding.

| Component | Purpose |
|---|---|
| `SessionStart` hook | Adds `rules/decisions.md`, the decision format, to the context on startup, `/clear`, and compaction. |
| `grilling:grilling` skill | The interview method. Triggered by "grill" phrases and by requests to stress-test a plan. |
| `grilling:grill-me` skill | User-invoked entry point, `/grilling:grill-me`, that starts a grilling session. |

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
| `drupal-security:validate-report` skill | Reproduces the reported vulnerability, scores its risk, and posts the assessment once the maintainer approves it. |
| `drupal-security:fix-vulnerability` skill | Fixes the highest supported branch in the private fork and backports the fix, one merge request per branch. |
| `drupal-security:draft-advisory` skill | Drafts the security advisory from the form link drupalbot posts. |
| `reference/workflow.md` | The security issue process, from report to published advisory. |
| `reference/risk-levels.md` | The risk score metrics, levels and conventions. |

Requires `glab` authenticated for git.drupalcode.org. Works best with the
drupal-contrib plugin installed: the skills use its local site and code skills
when they are present. With the chrome-devtools-mcp plugin installed,
`draft-advisory` offers to fill the advisory form in the browser.
