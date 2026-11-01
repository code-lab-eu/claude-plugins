---
name: draft-advisory
description: Drafts the Drupal security advisory for a confidential security work item, from the form link drupalbot posts after the `Security advisory::needed` label. Use when a Drupal security fix needs its advisory.
---

# Draft a security advisory

> Placeholder. The steps below are an outline to be worked out.

The process and its rules: [`../../reference/workflow.md`](../../reference/workflow.md).
The scoring: [`../../reference/risk-levels.md`](../../reference/risk-levels.md).
The form:
https://www.drupal.org/drupal-security-team/security-team-procedures/drafting-a-security-advisory

## Steps

1. Find drupalbot's link to the draft form in the work item.
2. Write the fields in the chat, in the order of the form:
   - **Security risk:** the six metric values, rechecked against the final fix.
   - **Vulnerability:** the type, such as "Access bypass".
   - **Description:** two or three paragraphs: what the project does, the
     vulnerability at a high level without exploit steps, and the mitigating
     factors.
   - **Solution:** every supported branch, highest version first, naming the
     unaffected ones, and any workaround.
   - **Reported by**, **Fixed by:** drupal.org usernames.
3. The maintainer fills the form from that text and saves the draft. When the
   chrome-devtools-mcp plugin is installed, offer to fill the form in the
   maintainer's logged-in browser instead, and leave saving to the
   maintainer.
4. Post the advisory link in the work item.

Done when the advisory link is in the work item.
