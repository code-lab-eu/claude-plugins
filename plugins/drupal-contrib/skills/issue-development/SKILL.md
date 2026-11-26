---
name: issue-development
description: Develops a change for a drupal.org issue in its public issue fork, creates the fork and the issue branch when they are missing, reads the issue and the reviewers' remarks, adds commits on top of other contributors' work and pushes them as a fast-forward. Use when asked to implement, start work on or do an iteration on an issue or work item, address a reviewer's remark, backport a change to another branch, or commit, push or rebase on an issue fork.
---

# Develop a change for an issue in its issue fork

The merge request branch is shared history: it holds the commits of everyone who
worked on the issue, and many contributors may be working from it. Every commit
already on the fork's branch stays as it is. New commits go on top of the fork's
remote head, so each push is a fast-forward.

Asking for an iteration, a change or a backport on an issue is the developer's
instruction to commit it and push it to the fork as the steps below describe:
the developer reviews it in the merge request. Creating the merge request and
posting a comment still wait for the developer to ask.

Comments are posted under the developer's account; see [Comments](#comments).

## Before you start

- `glab` is logged in to git.drupalcode.org:
  `GITLAB_HOST=git.drupalcode.org glab auth status` succeeds. Otherwise the
  developer runs `glab auth login --hostname git.drupalcode.org`. Pass
  `GITLAB_HOST=git.drupalcode.org` to every `glab` command, as `glab` defaults
  to gitlab.com.
- The developer's drupal.org account is linked to git.drupalcode.org, and an SSH
  key is on that profile.
- The checkout is a clone of the project or of the issue fork, and
  `git status --porcelain` prints nothing. When it lists a file, stop and show
  the list to the developer. Personal files belong in `.git/info/exclude`.
- The issue shows its fork as `<project>-<number>`. The fork's SSH URL is
  `git@git.drupal.org:issue/<project>-<number>.git`, and its branches start with
  `<number>-`. When the fork is already a remote, such as `origin`, use that
  remote's name for `<project>-<number>` below.

## Steps

1. Read the issue with its comments. For a work item on git.drupalcode.org, with
   the number from its URL:

   ```sh
   GITLAB_HOST=git.drupalcode.org glab issue view <number> -R project/<project> --comments
   ```

   For an issue on drupal.org, read the issue page. Then find the merge request,
   whose source branch starts with `<number>-`, and read it:

   ```sh
   GITLAB_HOST=git.drupalcode.org glab mr list -R project/<project> --search <number>
   GITLAB_HOST=git.drupalcode.org glab mr view <iid> -R project/<project> --comments
   ```

   When several merge requests are open, ask which one. The target branch is the
   merge request's target. For an issue without a merge request, it is the
   issue's version: the work item label `v<target>-dev`, such as `v3.x-dev` for
   `3.x`, or the Version field on drupal.org. When the issue names no version,
   ask. Note the other branches the issue asks the change for, such as a
   backport under Remaining tasks or in a comment.
2. Make sure the fork exists and the developer can push to it. The fork exists
   when `git ls-remote git@git.drupal.org:issue/<project>-<number>.git`
   succeeds; "The project you were looking for could not be found" means it does
   not. Create it on a work item with the `/do:fork` command:

   ```sh
   GITLAB_HOST=git.drupalcode.org glab issue note <number> -R project/<project> -m '/do:fork'
   ```

   The command holds no prose, so [Comments](#comments) does not apply to it.
   drupalbot answers with a "Fork created" note; repeat `git ls-remote` until it
   succeeds. On an issue on drupal.org, the developer creates the fork with
   "Create issue fork".

   Check push access with the developer's role on the fork:

   ```sh
   GITLAB_HOST=git.drupalcode.org glab api projects/issue%2F<project>-<number> \
     | jq .permissions.project_access.access_level
   ```

   30 or higher means the developer can push. A lower level or `null` means no
   push access: on a work item, post `/do:access` the same way as `/do:fork`,
   and repeat the check until it prints 30. On an issue on drupal.org, the
   developer clicks "Get push access". A `git push --dry-run` is no check: the
   server refuses a push in its pre-receive hook, which a dry run never reaches.
3. Add the fork as a remote named `<project>-<number>`, unless `git remote`
   already lists it, fetch it, and fetch the target branch from the project:

   ```sh
   git remote add <project>-<number> git@git.drupal.org:issue/<project>-<number>.git
   git fetch <project>-<number>
   git fetch git@git.drupal.org:project/<project>.git <target>
   ```

   When the issue has a merge request, switch to its source branch with
   `git switch <branch>`, which creates the local branch, tracking the fork's,
   when it does not exist yet.

   Without a merge request, look for a fork branch that starts with `<number>-`.
   Such a branch is usable as it is when it holds no commit that is not on the
   target:

   ```sh
   git merge-base --is-ancestor <project>-<number>/<branch> FETCH_HEAD
   ```

   When that fails, `git log --oneline FETCH_HEAD..<project>-<number>/<branch>`
   lists the commits the branch adds to the target. Use the branch when they are
   work on the issue. When they are the history of another project branch, such
   as the default branch that `/do:fork` starts its branch from, or when the
   fork has no `<number>-` branch, start the branch from the target and push it:

   ```sh
   git switch -c <number>-<words> FETCH_HEAD
   git push -u <project>-<number> <number>-<words>
   ```

   `<words>` are a few words from the issue title in lowercase, joined by
   hyphens, such as `3615365-respect-submission-limit`.
4. Make the change with `drupal-contrib:drupal-upstream-code`: load it before
   writing any code, comment or test. Checks run on the local site from
   `drupal-contrib:ddev-drupal-contrib`. The step is done when the skill's
   precedent report covers every construct in the diff, code and comments alike.
5. Commit with a plain message that says what the commit does, such as
   `Address PHPStan warnings`, with no prefix and no issue number.
6. Bring in commits pushed to the fork in the meantime, check that only your
   commits are new, and push. When the branch has a merge request, first load
   `drupal-contrib:wait-pipeline` and record its pipeline, with the path
   `project/<project>`.

   ```sh
   git fetch <project>-<number>
   git rebase --rebase-merges --autostash <project>-<number>/<branch>
   git log --oneline <project>-<number>/<branch>..HEAD
   git push <project>-<number> <branch>
   ```

   The rebase moves only the commits that are not on the fork yet, and `git log`
   lists exactly those. `--rebase-merges` keeps a merge of the target branch as
   a merge; without it, the rebase replays the target's commits onto the branch.
   Uncommitted changes the developer keeps in the tree are stashed for the
   rebase and come back after it.
7. Verify: the push is accepted. `! [rejected]` with `fetch first` means the
   fork moved: repeat step 6. "You are not allowed to push code to this project"
   means the developer has no push access yet; see step 2.
8. When the developer asks for the merge request, create it from the fork's
   branch into the target branch, with drupal.org's default title and
   description:

   ```sh
   GITLAB_HOST=git.drupalcode.org glab mr create -R project/<project> \
     --head issue/<project>-<number> -s <branch> -b <target> \
     -t 'Resolve #<number> "<issue title>"' -d 'Closes #<number>' --yes
   ```

   Then name the other branches noted in step 1 to the developer, and offer to
   start each with [Backport to another branch](#backport-to-another-branch).
9. When the branch has a merge request, wait for its pipeline with
   `drupal-contrib:wait-pipeline`. The step is done when the pipeline succeeds.
   When it fails, fix the failing job in a new commit.

## Backport to another branch

When the developer asks for the change on another branch, such as `2.x`, the
work happens in a worktree of its own, beside the checkout, with a local site
built from that branch's dependencies. The checkout and its site stay on their
branch. `git worktree list` shows whether the worktree exists from an earlier
backport to that branch.

Start a branch from the project's current `<target>`, named after the merge
request branch with the target appended, in a new worktree, or with
`git switch -c` in the existing one, and push it to the fork:

```sh
git fetch git@git.drupal.org:project/<project>.git <target>
git worktree add -b <branch>-<target> ../<checkout>-<target> FETCH_HEAD
cd ../<checkout>-<target>
git push -u <project>-<number> <branch>-<target>
```

`<checkout>` is the checkout's directory name. Set up the worktree's site with
`drupal-contrib:ddev-drupal-contrib` when it has none, and run every command for
the branch in the worktree, as in `cd ../<checkout>-<target> && ddev phpunit …`.

Apply the change of the merge request you backport from, open or merged:

```sh
GITLAB_HOST=git.drupalcode.org glab mr diff <iid> -R project/<project> --raw | git apply --3way
```

The diff starts at the merge base, so it holds the issue's change and nothing
the branch merged in from its target. `git status` shows a conflicting file as
`UU`. Resolve it for the code on the new branch and `git add` it. Resolving a
conflict is writing code: load `drupal-contrib:drupal-upstream-code` before the
first one. The precedent report covers the resolved conflicts and the commits
only this branch has; for the code applied unchanged, it cites the merge request
you backport from. Then follow steps 4 to 9 on the new branch, with
`-b <target>` in step 8.

While the merge request you backport from is open, each commit pushed to it goes
to every backport branch as well. In each backport worktree, run
`git cherry-pick <commit>` and follow steps 6 to 9. A commit that only one
branch needs, such as one for a dependency version of that branch, stays on that
branch.

## Comments

drupal.org's
[AI policy](https://www.drupal.org/docs/develop/issues/issue-procedures-and-etiquette/policy-on-the-use-of-ai-when-contributing-to-drupal)
requires a human-written statement at the end of every comment that AI helped
write. Draft each comment in Markdown and end it with this placeholder:

```
AI disclosure: <write what AI was used for>
```

Post it only after the developer has replaced the placeholder with their own
words and asks for it. On a work item:

```sh
GITLAB_HOST=git.drupalcode.org glab issue note <number> -R project/<project> \
  -m "$(cat <draft file>)"
```

The command prints the comment's URL. Report it. On an issue on drupal.org, the
developer posts it.

## Never

- Force-push to the fork, or rebase the merge request onto the target branch.
- Amend, squash, rebase or drop a commit that is already on the fork.
