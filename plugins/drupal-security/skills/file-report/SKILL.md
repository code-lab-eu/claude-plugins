---
name: file-report
description: Files a new confidential Drupal security report for a vulnerability that no security work item covers yet, and checks that its private fork is created. Use when a vulnerability turns up outside the reports at hand, such as one found while reviewing or fixing another report.
---

# File a security report

The process and its rules:
[`../../reference/workflow.md`](../../reference/workflow.md). Filing starts the
Report stage described there.

Ask the maintainer before filing, and show the report as a draft first.

## Steps

1. Search the project's work items, as under Finding the work items in
   `workflow.md`, and the project's public issue queue. When one covers the
   vulnerability, show it to the maintainer instead of drafting a report.
2. Reproduce the vulnerability on the public code: the latest commit of each
   supported branch, which a fork's branch equals once it is up to date as
   described under Environment in `workflow.md`. Find the first release that has
   the vulnerable code, such as with `git log -S` and `git tag --contains`. A
   vulnerability that only an unreleased fix brings in is a finding for that
   fix, not a report.
3. Draft the report in Drupal's issue summary template: Problem/Motivation with
   the cause by `path:line`, Steps to reproduce from a fresh install with the
   permissions the attacker needs, the affected releases, and Proposed
   resolution. The title is `<machine_name>: <title>`; the automation finds the
   project by that prefix. End with the AI disclosure placeholder.
4. Once the maintainer approves the draft, file it in the security team's intake
   project through the GitLab API, with the title and the draft's body in a JSON
   file:

   ```sh
   jq -n --arg title '<machine_name>: <title>' --rawfile description <draft> \
     '{title: $title, description: $description, confidential: true}' > report.json
   glab api --hostname git.drupalcode.org --method POST \
     "projects/drupal-security%2Fissues/issues" \
     -H 'Content-Type: application/json' --input report.json
   ```

   The security team documents the web form
   `https://git.drupalcode.org/drupal-security/issues/-/issues/new?issue[confidential]=true`;
   the API files the same confidential issue.
5. Check that the automation took the report: within a minute the intake issue's
   `moved_to_id` is set, and the search from step 1 lists it as work item 1 of a
   new fork `security/<id>-<machine_name>-security` with
   `Security status::unvalidated`. When it does not, give the maintainer the
   intake issue's URL to raise with the security team.

Done when the report is work item 1 of its private fork and the maintainer has
its URL.
