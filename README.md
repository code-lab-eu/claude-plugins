# Code Lab Claude Code plugins

Claude Code plugin marketplace for Code Lab.

## Installation

Per developer, for all projects:

```
/plugin marketplace add <git URL of this repository>
/plugin install self-improvement-loop@code-lab
```

Per project, for every contributor, in the committed `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "code-lab": {
      "source": {
        "source": "git",
        "url": "<git URL of this repository>"
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
