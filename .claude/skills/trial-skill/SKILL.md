---
name: trial-skill
description: Trials a skill from a plugin in this repository on real work before release, in a separate worker session, and feeds the findings back into the skill. Use when a skill in development is to be tried out on a real task.
---

# Trial a skill in development

A worker session runs the skill on the real task, in the target project. This
session evaluates the run and improves the skill. The worker's context stays
clean: it sees the skill and the task, never the evaluation.

## Steps

1. Agree the target with the developer: the task, and the project the worker
   runs in. Clear what an earlier run left in that project, such as untracked
   files and its session note, so the run starts clean.
2. Give the developer the command that starts the worker in the target
   project, with a `--plugin-dir` for each plugin of this working tree that
   the skill uses, and the skill invocation:

   ```sh
   cd <project> && claude --plugin-dir <repo>/plugins/<plugin> --plugin-dir ...
   ```

   An installed copy only updates on a new version; `--plugin-dir` loads the
   working tree. A running worker keeps the skill text it started with, so
   start it after the last edit to the skill, or have the developer run
   `/reload-skills` in it. The developer answers the worker's questions and
   permission prompts.
3. Find the worker with `ListAgents` and send it the task with `SendMessage`,
   with `notify_when_idle`: the skill, its target, and a request to report
   back by `SendMessage` when it is done or blocked, with what did not fit the
   skill. The message holds the task only, never the evaluation.
4. When the worker reports, or the developer says the run is done, read the
   worker's transcript, the newest `.jsonl` file in `~/.claude/projects/<project
   path, with each character other than a letter or digit replaced by ->/`,
   and the files the run produced:

   ```sh
   python3 -I <repo>/.claude/skills/trial-skill/digest.py <transcript>
   ```

5. Evaluate the run against the skill: what went well, where it strayed, and
   what the developer had to correct. A change earns its place when it applies
   to every run of the skill, not just this task; a problem the worker solved
   unaided needs no instruction.
6. Propose the changes to the developer, apply the ones they choose, and start
   the next run.

Done when the developer ends the trials. Progress and findings live in the
session note; the findings reach the repository only as changes to the skill.
