# Code Lab Claude Code plugins

A plugin marketplace: `.claude-plugin/marketplace.json` lists the plugins under
`plugins/`.

## Conventions

- Wrap Markdown prose at 80 columns. When editing a paragraph, rewrap it so
  every line matches the wrapping of its neighbours.
- Every change to a plugin's files bumps `version` in its
  `.claude-plugin/plugin.json`; installed copies only update on a new version.
- Keep `README.md` in step with each plugin's components (hooks, skills,
  rules).
- Future work goes in `docs/roadmap.md`.
