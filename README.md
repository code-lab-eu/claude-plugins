# Code Lab Claude Code plugins

Claude Code plugin marketplace for Code Lab.

## Installation

Per developer, for all projects:

```
/plugin marketplace add git@github.com:code-lab-eu/claude-plugins.git
/plugin install self-improvement-loop@code-lab
/plugin install drupal-contrib@code-lab
/plugin install grilling@code-lab
```

Per project, for every contributor, in the committed `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "code-lab": {
      "source": {
        "source": "git",
        "url": "git@github.com:code-lab-eu/claude-plugins.git"
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
| `Stop` hook | Blocks the first stop of each turn with a reminder to update the session note. |
| `self-improvement-loop:close` skill | Promotes findings from the note into durable homes. Triggered by "wrap up", "end the session", or "run the self-improvement loop". |

Session notes are per developer and are never committed. The rule adds
`docs/notes/` to `.git/info/exclude` when the directory is not already ignored.

Requires `jq`.

### drupal-contrib

Local development of Drupal contrib modules and themes. Nothing it sets up is
committed to the project's repository.

| Component | Purpose |
|---|---|
| `drupal-contrib:ddev-drupal-contrib` skill | Sets up a local DDEV site for a contrib checkout, such as a drupal.org issue fork, with the ddev-drupal-contrib add-on, and keeps its files out of git through `.git/info/exclude`. |

Requires DDEV.

### grilling

Grills the developer about a plan until both share an understanding of it. Each
message asks one question, with options, pros and cons, best practice, and a
recommendation. Nothing is acted on before the developer confirms the shared
understanding.

| Component | Purpose |
|---|---|
| `grilling:grilling` skill | The interview method. Triggered by "grill" phrases and by requests to stress-test a plan. |
| `grilling:grill-me` skill | User-invoked entry point, `/grilling:grill-me`, that starts a grilling session. |

Adapted from the MIT-licensed skills of Matt Pocock; see
`plugins/grilling/LICENSE`.
