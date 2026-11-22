# Session notes — 2026-11-20-table-real-links

**Date:** 2026-11-20
**Topic:** Replace `onclick` table rows with real links

## Lessons learned

## Developer corrections

- Converting a row `onclick` into an `<a>` turned the bold black name into a
  blue link: "visual regression, keep the link styling from before". Fix:
  `text-reset text-decoration-none` on the link (computed: black, 700, no
  underline). Rule: a markup change for accessibility must keep the rendered
  look unless the developer asks otherwise; compare computed styles before
  reporting.

## Non-trivial discovery

- Only two templates use row `onclick`: `products.html` and
  `_order_row.html`. Customers have no detail page, so `_customer_row.html` gets no
  link.
- `base.html` set `cursor: pointer` on every `.table-hover` row, also on tables
  without any row link (customers, recent activity).
- Bootstrap `stretched-link` on a `<tr class="position-relative">` clips the
  overlay to the row in Chrome; the action cell needs `position-relative z-2`
  to stay clickable. Verified with `document.elementFromPoint` via Chrome
  DevTools MCP against `shop-admin serve --port 8765`.
- `pkill -f "shop-admin serve ..."` from the Bash tool exits 144: the pattern
  also matches the tool's own shell command line, which gets killed.

## Skill gaps

## Repeated attempts / struggles

## Inconsistencies & conflicts

- AGENTS.md: "A task is NOT complete until the corresponding pull request has
  been created"; global CLAUDE.md: never commit without an express
  instruction. Resolved by stopping before the commit until the developer said
  "commit staged changes, push, create PR".

## Automatable repetition

## Knowledge gaps

## Project / agent-improvement facts

## Actionable findings (filled at loop close)
