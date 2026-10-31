---
name: validate-report
description: Validates a vulnerability report in a confidential Drupal security work item on git.drupalcode.org, scores its risk, and posts the assessment. Use when a Drupal Security Team report about a maintained project comes in.
---

# Validate a security report

> Placeholder. The steps below are an outline to be worked out.

The process and its rules: [`../../reference/workflow.md`](../../reference/workflow.md).
The scoring: [`../../reference/risk-levels.md`](../../reference/risk-levels.md).

## Steps

1. Read the work item and its comments.
2. Check eligibility: covered project, affected stable release of a supported
   branch, code hosted on drupal.org, no advanced permission needed.
3. Reproduce the vulnerability on a local site for the highest supported
   branch.
4. Score the risk on all six metrics, with a reason for each value.
5. Search the project for the same pattern elsewhere.
6. Post the findings as a comment on the work item, ending with the AI
   disclosure.
7. Add the label `Security advisory::needed`.

Done when the comment and the label are on the work item.
