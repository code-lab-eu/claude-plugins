---
name: issue-fork
description: Iterates on a drupal.org issue in its public issue fork, reads the issue and the reviewers' remarks, fetches the fork's merge request branch, adds commits on top of other contributors' work and pushes them as a fast-forward. Use when asked to do an iteration on an issue or work item, address a reviewer's remark, or commit, push or rebase on an issue fork.
---

# Iterate on an issue in its issue fork

The merge request branch is shared history: it holds the commits of everyone
who worked on the issue, and many contributors may be working from it. Every
commit already on the fork's branch stays as it is. New commits go on top of
the fork's remote head, so each push is a fast-forward.

The developer creates forks and merge requests and comments on the issue, on
drupal.org or GitLab.

## Before you start

- `glab` is logged in to git.drupalcode.org:
  `GITLAB_HOST=git.drupalcode.org glab auth status` succeeds. Otherwise the
  developer runs `glab auth login --hostname git.drupalcode.org`. Pass
  `GITLAB_HOST=git.drupalcode.org` to every `glab` command, as `glab` defaults
  to gitlab.com.
- The developer has push access to the issue fork: their drupal.org account is
  linked to git.drupalcode.org, an SSH key is on that profile, and they
  clicked "Get push access" on the issue, or commented `/do:access` on a
  GitLab work item.
- The checkout is a clone of the project or of the issue fork, and
  `git status --porcelain` prints nothing. When it lists a file, stop and show
  the list to the developer. Personal files belong in `.git/info/exclude`.
- The issue shows its fork as `<project>-<number>`. The fork's SSH URL is
  `git@git.drupal.org:issue/<project>-<number>.git`, and its branches start
  with `<number>-`. When the fork is already a remote, such as `origin`, use
  that remote's name for `<project>-<number>` below.

## Steps

1. Read the issue with its comments. For a work item on git.drupalcode.org,
   with the number from its URL:

   ```sh
   GITLAB_HOST=git.drupalcode.org glab issue view <number> -R project/<project> --comments
   ```

   For an issue on drupal.org, read the issue page. Then find the merge
   request, whose source branch starts with `<number>-`, and read it:

   ```sh
   GITLAB_HOST=git.drupalcode.org glab mr list -R project/<project> --search <number>
   GITLAB_HOST=git.drupalcode.org glab mr view <iid> -R project/<project> --comments
   ```

   When the issue has no fork or no merge request, stop: the developer creates
   them. When several merge requests are open, ask which one.
2. Add the fork as a remote named `<project>-<number>`, unless `git remote`
   already lists it, fetch it, and switch to the branch:

   ```sh
   git remote add <project>-<number> git@git.drupal.org:issue/<project>-<number>.git
   git fetch <project>-<number>
   git switch <branch>
   ```

   `git switch` creates the local branch, tracking the fork's, when it does
   not exist yet.
3. Make the change. The code follows `drupal-contrib:drupal-upstream-code`,
   and checks run on the local site from `drupal-contrib:ddev-drupal-contrib`.
4. Commit with a plain message that says what the commit does, such as
   `Address PHPStan warnings`, with no prefix and no issue number.
5. Bring in commits pushed to the fork in the meantime, check that only your
   commits are new, and push:

   ```sh
   git fetch <project>-<number>
   git rebase <project>-<number>/<branch>
   git log --oneline <project>-<number>/<branch>..HEAD
   git push <project>-<number> <branch>
   ```

   The rebase moves only the commits that are not on the fork yet, and
   `git log` lists exactly those.
6. Verify: the push is accepted. `! [rejected]` with `fetch first` means the
   fork moved: repeat step 5. "You are not allowed to push code to this
   project" means the developer has no push access yet; see
   [Before you start](#before-you-start).

## Never

- Force-push to the fork, or rebase the merge request onto the target branch.
- Amend, squash, rebase or drop a commit that is already on the fork.
