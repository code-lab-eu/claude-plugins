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

## Correct over easy

Choose the correct solution, not the one with less work or less change.

- Fix the root cause. Never prefer an option for its smaller diff, fewer files,
  or reuse of a file that does not fit.
- Never offer an option that bypasses a project rule, works around a defect, or
  moves work that belongs in this change to a separate ticket.
- Read the source (code, skill, README) before stating how something behaves.
- Verify with the check the task calls for: run what the project prescribes
  before a push, and walk through steps instead of simulating them. When a check
  cannot run, say so instead of substituting a cheaper one.
- Take an instruction in its full sense, and do the work instead of handing it
  back.
