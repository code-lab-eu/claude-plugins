---
name: move-to-public
description: Moves a confidential Drupal security report that gets no security advisory to the project's public issue queue, drafts the public issue, and closes the work item with a link to it. Use when the maintainer decides to fix a security report in public.
---

# Move a security report to the public queue

The process and its rules:
[`../../reference/workflow.md`](../../reference/workflow.md). When a report
may go public is described under Eligibility there.

Ask the maintainer before filing the issue and before posting the comment,
and show both as drafts first.

## Steps

1. Draft the public issue in Drupal's issue summary template, with
   `drupal-contrib:issue-queue` when the drupal-contrib plugin is installed.
   The issue holds what a contributor needs to fix the problem: what goes
   wrong, at a high level, and the affected code by file and function, for
   the report and each occurrence the validation found. It credits the
   reporter by drupal.org username, and says that the report came in
   privately and is public because it gets no advisory, with the reason, such
   as no stable release. Reproduction steps, payloads, preconditions and how
   the validation confirmed the report stay in the work item; they replace
   issue-queue's Steps to reproduce and its rule to state how each fact was
   checked.
2. File the issue once the maintainer approves the draft.
3. Comment in the work item with the link to the public issue, thank the
   reporter and the security team members who took part, and close the work
   item with a `/close` line in the comment.

Done when the public issue is filed and the closed work item links to it.
