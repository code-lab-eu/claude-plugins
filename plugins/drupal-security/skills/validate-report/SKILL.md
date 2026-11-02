---
name: validate-report
description: Validates a vulnerability report in a confidential Drupal security work item on git.drupalcode.org, scores its risk, and drafts the assessment for the maintainer to post. Use when a vulnerability report about a maintained project comes in.
---

# Validate a security report

> Placeholder. The steps below are an outline to be worked out.

The process and its rules: [`../../reference/workflow.md`](../../reference/workflow.md).
The scoring: [`../../reference/risk-levels.md`](../../reference/risk-levels.md).

## Steps

1. Read the work item and its comments.
2. Check eligibility: covered project, affected stable release of a supported
   branch, code hosted on drupal.org, no advanced permission needed. The
   release history at
   `https://updates.drupal.org/release-history/<machine_name>/current` lists
   the supported branches, the releases and their security coverage.
3. Reproduce the vulnerability with a failing test on the highest supported
   branch, in the project's environment. The test stays uncommitted, since it
   shows how to exploit the issue. When it cannot be reproduced, the comment
   says so.
4. Search the project for the same pattern elsewhere, and reproduce each
   occurrence the same way.
5. Score the risk of the reproduced vulnerabilities on all six metrics, with a
   reason for each value: one score for the work item.
6. Draft the findings as a comment on the work item, as described under
   [The comment](#the-comment), and give the maintainer the draft to review.
7. Once the maintainer has replaced the AI disclosure placeholder and approves
   the draft, post the comment and add the label `Security advisory::needed`.

Done when the maintainer has the draft. Posting waits for their approval.

## The comment

The readers are the security team and the reporter. The comment holds only
what they can see or repeat themselves:

- Eligibility, point by point.
- Whether the report reproduces, with steps they can follow on a site, and the
  vulnerable code by file and function.
- The score in the notation of `risk-levels.md`, with the reason per metric.
- The same pattern elsewhere: each reproduced occurrence with its steps, and
  each unreproduced one marked as suspected, with its code location. Suspected
  occurrences leave the score unchanged.
- The maintainer's AI disclosure placeholder as the last line.

The comment states the problem; the fix is described in its merge request.
Local work, such as the test, and notes meant for the maintainer go to the
maintainer in the session.
