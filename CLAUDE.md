# Code Lab Claude Code plugins

A plugin marketplace: `.claude-plugin/marketplace.json` lists the plugins under
`plugins/`.

## Conventions

- Wrap Markdown prose at 80 columns. When editing a paragraph, rewrap it so
  every line matches the wrapping of its neighbours.
- Bump `version` in a plugin's `.claude-plugin/plugin.json` once per
  completed piece of work, such as a pull request or a finished task on
  `master`, not per commit; installed copies only update on a new version.
- Keep `README.md` in step with each plugin's components (hooks, skills,
  rules): one short sentence of purpose per component; the details live in
  the component.
- Future work goes in `docs/roadmap.md`.
