#!/bin/bash
# Creates the project that the session in the note worked on, in the current
# directory, as a git repository with the note excluded from version control.
set -euo pipefail

cp -r "$(dirname "$0")/project/." .
git init --quiet
echo 'docs/notes/' >> .git/info/exclude
git add .
git -c user.name=Eval -c user.email=eval@example.com commit --quiet -m 'Initial commit'
