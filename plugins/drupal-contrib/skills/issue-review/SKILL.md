---
name: issue-review
description: Reviews the merge request of a drupal.org issue, checks each finding on the local site, and drafts the review for the work item before any change is pushed. Use when asked to review a merge request, or an issue in Needs review.
---

# Review the merge request of an issue

The review is posted under the developer's account. Every claim in it is
checked on the local site.

## Before you start

- The checkout is on the merge request's branch: steps 1 and 2 of
  `drupal-contrib:issue-fork` read the issue and fetch the branch.
- The local site from `drupal-contrib:ddev-drupal-contrib` runs the project's
  tests.

## Steps

1. Read the issue summary, whether it is a bug report, a feature request or a
   task, and the merge request. Search the project for every other place that
   is affected by the change, such as other calls to the same API or code that
   depends on the changed code. The step is done when each place is listed as
   handled by the merge request or not, with the reason.
2. Test the merge request and its side effects on the local site. Run the
   project's tests on the merge request's branch and on the target branch.
   Confirm each finding with a throwaway test in `web/scratch/`, which
   ddev-drupal-contrib excludes from git and DDEV mounts in the container:

   ```sh
   ddev phpunit web/scratch/<Name>Test.php -c web/core/phpunit.xml.dist
   ```

   The step is done when every finding is confirmed by a test or a command.
   Delete `web/scratch/` once the review is posted.
3. Draft the review, following [Comments](../issue-fork/SKILL.md#comments) in
   issue-fork:
   - Whether the merge request does what the issue summary asks, and any side
     effects.
   - Each problem with `path:line`, steps to reproduce and the result, and how
     it was confirmed.
   - The requested changes, such as missing test coverage, as a numbered list.

   Review the merge request as it is now, without mentioning changes you plan
   to push.
4. When the review requests changes, the issue status becomes Needs work
   (`state::needsWork` on a work item). The developer sets the status; on a
   work item it may need maintainer rights.
5. Once the review is posted and the developer asks for the changes, make them
   with `drupal-contrib:issue-fork`.
