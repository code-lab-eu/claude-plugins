#!/bin/bash
# Local QA gate: the same checks as CI.
set -euo pipefail

uv run --extra dev ruff check src/ tests/
uv run --extra dev ruff format --check src/ tests/
uv run --extra dev mypy src/
uv run --extra dev pytest
