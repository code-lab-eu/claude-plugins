# AGENTS.md — Shop Admin

Instructions for AI coding agents and human contributors working on this
codebase. Read this before writing any code.

## Agent rules

Working practices that apply to every session live in `.agents/rules/`. Read and
follow them:

- Self-improvement loop: keep a session note in `docs/notes/`, then promote
  durable learnings into rules, skills, and docs when the loop closes.

## Project overview

Back-office dashboard of an online shop: FastAPI + HTMX + Jinja2.

## Branch and PR discipline

- Create a feature branch off master before touching any code.
- When your work is complete, push your branch and open a pull request against
  master. A task is NOT complete until the pull request has been created and
  all required CI checks pass.

## Common commands

```bash
# Full QA gate (ruff lint, ruff format check, mypy, pytest); run before every push
scripts/qa.sh

# Start the web dashboard
uv run shop-admin serve
```

## Project layout

```
src/shop_admin/
  cli.py                  # Typer CLI
  feeds/playwright_fetch.py  # Renders supplier pages to import prices (scraping)
  web/app.py              # FastAPI app and routes
  web/templates/          # Jinja2 templates
tests/
  test_web.py             # Dashboard routes, asserted on the response HTML
scripts/qa.sh             # Local QA gate
.github/workflows/shop-admin-ci.yml  # CI: lint, format check, mypy, tests
```

## Code style & conventions

- **Line length:** 100 characters
- **Quote style:** double quotes (enforced by ruff format)
- **Imports:** `from __future__ import annotations` at the top of every
  type-annotated module
- **Types:** type hints on all public functions
- **Async:** all database operations and HTTP calls are `async`

## Testing

- **Test runner:** pytest with `asyncio_mode = "auto"`
- **Database:** use the real PostgreSQL database, never a mock
- **Web:** FastAPI `TestClient`, asserting on the response HTML
- **Before pushing:** run `scripts/qa.sh`; it must exit green

## Contribution workflow

Give every GitHub issue one label `priority:high`, `priority:normal` or
`priority:low`.
