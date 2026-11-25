---
name: review-fix
description: Reviews the merge request that fixes a confidential Drupal security work item, checks on the local site that it closes the vulnerability on every path, and drafts the review for the work item. Use when asked to review a security fix, or a work item in Security status::needs review.
---

# Review a security fix

The process and its rules:
[`../../reference/workflow.md`](../../reference/workflow.md).

The report has been validated; the review judges the fix. Every claim in the
review is checked on the local site. The review pushes nothing to the fork; the
changes it requests are for the fix's author. A tracked file changed to test the
fix is restored before the review ends, so that `git status --porcelain` prints
nothing again.

Ask the maintainer before posting the comment and before setting labels, and
show the comment as a draft first.

## Steps

1. Check that the session runs in a clone of the work item's private fork, as
   described under Environment in `workflow.md`.
2. Read the work item, its comments, and each merge request of the fix with the
   latest pipeline of each. List the supported branches the vulnerability
   affects, from the release history at
   `https://updates.drupal.org/release-history/<machine_name>/current`. Each of
   them needs a merge request; a missing one is a finding.
3. Review each merge request, the highest branch first:
   1. Bring its target branch up to date, as described under Environment in
      `workflow.md`. Check out the merge request's branch detached, and merge
      the up-to-date target branch into it locally, so that the review tests the
      fix on the code it will be applied to. A conflict is a finding. Rebuild
      the local site for the branch, with `ddev poser` in a ddev-drupal-contrib
      setup.
   2. Run the project's tests on this checkout and on the target branch. The
      step is done when every failure, there and in the pipeline, has its cause:
      the change, the target branch, or the merge request's outdated base that
      the target branch has since fixed.
   3. Follow the reproduction steps of the report and of the validation comment
      in full on the installed local site, through the interface the report
      uses, such as HTTP requests to an endpoint, and check that each is now
      blocked. A kernel test does not replace this: it skips routing, the
      endpoint's permissions and response caching. Observe an effect that shows
      only in a browser with the chrome-devtools-mcp plugin's tools. Check that
      the merge request's test fails with only the test applied on the target
      branch, and passes with the fix.
   4. Attack the fix as the reporter would, and look for a bypass: other syntax
      for the same input, such as an alias, an encoding, a case variant or a
      nested structure; other entry points that reach the vulnerable code; the
      occurrences of the same pattern that validation found. The step is done
      when every entry point to the vulnerable code is listed as closed or open,
      with the test or the steps that show it. Tests cover the closed variants;
      each open bypass is shown by its steps, followed as in the step above.
   5. Check the side effects: what legitimate users can no longer do, changes to
      public API and constructors, and the cacheability of the access results.
   6. Check what the diff discloses. The diff goes public at the release: code
      comments, test names and fixtures name the behaviour, not the exploit, and
      a test that reveals more than the fix follows the Confidentiality rules in
      `workflow.md`. Commit messages are neutral.
   7. When the drupal-contrib plugin is installed, check the code against
      `drupal-contrib:drupal-upstream-code`.

   Confirm each finding with a test or a command on the local site. Keep
   throwaway tests out of git, such as in `web/scratch/` in a
   ddev-drupal-contrib setup.
4. A gap that is itself a vulnerability, also one the merge request names as out
   of scope, is fixed with this fix or reported as a finding in the work item. A
   public follow-up issue would disclose it before the advisory. A bug that is
   not a vulnerability goes to the maintainer in the session, for the public
   issue queue, described so that it reveals nothing of the vulnerability. The
   comment mentions it only where it bears on the review, such as a check it
   blocked.
5. Draft the review as a comment on the work item, as described under
   [The comment](#the-comment), and give the maintainer the draft to review.
6. Once the maintainer has replaced the AI disclosure placeholder and approves
   the draft, post the comment and set the status label: a review that requests
   changes sets `Security status::needs work`, one that requests none sets
   `Security status::needs review` for the security team, which sets
   `Security status::reviewed & tested`. After posting, delete the throwaway
   tests.

Done when the maintainer has the draft of a review in which every merge request
and every entry point was checked, or knows what blocks it. Posting waits for
their approval.

## The comment

The readers are the fix's author, the co-maintainers and the security team. The
comment claims only what this run observed:

- Per merge request, whether it closes the report, with the steps followed and
  the result.
- Each problem with `path:line`, the steps or the test that shows it, and the
  result. A bypass gets steps the author can follow on a site.
- Each pipeline failure with its cause.
- The requested changes as a numbered list.
- The maintainer's AI disclosure placeholder as the last line.

Review the merge requests as they are now; the changes are the author's to make.
