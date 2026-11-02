---
name: validate-report
description: Validates a vulnerability report in a confidential Drupal security work item on git.drupalcode.org, scores its risk, and drafts the assessment for the maintainer to post. Use when a vulnerability report about a maintained project comes in.
---

# Validate a security report

> Placeholder. The steps below are an outline to be worked out.

The process and its rules:
[`../../reference/workflow.md`](../../reference/workflow.md). The scoring:
[`../../reference/risk-levels.md`](../../reference/risk-levels.md).

## Steps

1. Read the work item and its comments.
2. Check eligibility: covered project, affected stable release of a supported
   branch, code hosted on drupal.org, no advanced permission needed. The
   release history at
   `https://updates.drupal.org/release-history/<machine_name>/current` lists
   the supported branches, the releases and their security coverage.
3. Reproduce the vulnerability with a failing test on the highest supported
   branch, in the project's environment. The test stays uncommitted, since it
   shows how to exploit the issue. An effect that shows only in a browser,
   such as a script running, is observed by following the steps on the local
   site with the chrome-devtools-mcp plugin's tools. When a complete attempt
   does not reproduce the report, that is the finding.
4. Search the project for the same pattern elsewhere, and reproduce each
   occurrence the same way.
5. Score the risk of the reproduced vulnerabilities on all six metrics, with a
   reason for each value: one score for the work item, for the most severe
   path that was reproduced. Each reason names the definition in
   `risk-levels.md` that it meets, and the value is the one whose definition
   matches.
6. Check that the validation is complete: every effect in the report and
   every occurrence from step 4 was observed, in a failing test or in the
   browser, or a complete attempt showed that it does not reproduce. This
   holds for each occurrence found, also one that shares code with a reproduced
   one or is left out of the comment. When a step is blocked, for example
   because the local site, the browser or the chrome-devtools-mcp plugin is
   missing, stop here: tell the maintainer what blocks it, and leave the comment
   undrafted.
7. Draft the findings as a comment on the work item, as described under
   [The comment](#the-comment), and give the maintainer the draft to review.
8. Once the maintainer has replaced the AI disclosure placeholder and approves
   the draft, post the comment, add the labels `Security advisory::needed`
   and `Security status::validated`, and remove `Needs maintainer response`
   when it is set: the comment is the response it asks for.

Done when the maintainer has the draft of a complete validation, or knows what
blocks it. Posting waits for their approval.

## The comment

The readers are the security team and the reporter. The comment holds only
what they can see or repeat themselves, and claims only what this run
observed, in a failing test or in the browser:

- Eligibility, point by point.
- Whether the report reproduces, with steps they can follow on a site, and the
  vulnerable code by file and function.
- The score in the notation of `risk-levels.md`, with the reason per metric.
- The same pattern elsewhere: each reproduced occurrence with its steps and
  its code location.
- The maintainer's AI disclosure placeholder as the last line.

The comment states the problem; the fix is described in its merge request.
Local work, such as the test, and notes meant for the maintainer go to the
maintainer in the session.
