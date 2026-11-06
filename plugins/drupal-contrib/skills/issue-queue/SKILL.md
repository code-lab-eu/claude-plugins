---
name: issue-queue
description: Searches a drupal.org project's issue queue for an existing issue, drafts a new issue in Drupal's issue summary template, files it as a work item on git.drupalcode.org, and updates its labels after the merge. Use when asked whether an issue exists, to draft or file an issue, or to close or relabel one.
---

# Search, draft and file drupal.org issues

An issue is public and goes out under the developer's account. The developer
reviews every draft before it is filed.

## Before you start

- Find where the project's issue queue lives:

  ```sh
  curl -s -o /dev/null -w '%{http_code} %{redirect_url}\n' \
    https://www.drupal.org/project/issues/<project>
  ```

  A 301 to `https://git.drupalcode.org/project/<project>/-/work_items` means
  the queue is migrated to GitLab work items: every step below applies. A 200
  means it is still on drupal.org: search it on that page, with
  `?text=<term>&status=All`, draft the issue, and the developer files it.
- For a migrated queue, `glab` is logged in to git.drupalcode.org:
  `GITLAB_HOST=git.drupalcode.org glab auth status` succeeds. Pass
  `GITLAB_HOST=git.drupalcode.org` to every `glab` command.

## Steps

1. Search titles and descriptions, once for each term: the class or method
   name, the error message, and the problem in plain words.

   ```sh
   GITLAB_HOST=git.drupalcode.org glab api \
     "projects/project%2F<project>/issues?search=<term>&state=all&per_page=100"
   ```

   Report each match with its number, title, state and version label. A closed
   match may have fixed the problem on another branch: a change that ports it
   is a backport of that issue. The step is done when every term is searched.
2. Draft the issue in Drupal's issue summary template, with `###` headings:
   Problem/Motivation, Steps to reproduce (for a bug), Proposed resolution,
   Remaining tasks, User interface changes, API changes, Data model changes.
   - A backport names its original issue and commit in the title or the first
     sentence.
   - Cite code as `path:line`, and state each fact with how it was checked.
   - End with `_Drafted with AI assistance and reviewed by me._`. drupalbot
     cites the AI contribution policy on every new issue:
     https://www.drupal.org/docs/develop/issues/issue-procedures-and-etiquette/policy-on-the-use-of-ai-when-contributing-to-drupal
3. Choose the labels from those a recent open issue of the project carries,
   such as `category::task,code,priority::normal,state::accepted,v3.x-dev`:
   a `category::`, a component, a `priority::`, `state::accepted` for a new
   issue, and the version as `v<branch>-dev`.

   ```sh
   GITLAB_HOST=git.drupalcode.org glab issue list -R project/<project> \
     --per-page 5 --output json | jq -r '.[].labels | join(",")'
   ```

4. Show the draft, title and labels to the developer, and file the issue only
   when they approve:

   ```sh
   GITLAB_HOST=git.drupalcode.org glab issue create -R project/<project> \
     --title '<title>' --description "$(cat <draft file>)" \
     --label '<labels>' --no-editor --yes
   ```

   The command prints the work item's URL. Report it.

## After the merge

A merge request with `Closes #<number>` closes the work item when it is merged,
but leaves its `state::` label. When the developer asks, replace it with the
label the project's merged issues carry, such as `state::closed`:

```sh
GITLAB_HOST=git.drupalcode.org glab api -X PUT \
  "projects/project%2F<project>/issues/<number>" \
  -f remove_labels='state::accepted' -f add_labels='state::closed'
```
