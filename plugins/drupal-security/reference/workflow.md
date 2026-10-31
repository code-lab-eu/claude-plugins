# Drupal security issue workflow

How a vulnerability reported in a drupal.org project goes from the private
report to a published security advisory (SA), from the maintainer's side.

Sources, checked 2026-10-31:

- https://www.drupal.org/drupal-security-team/contacted-by-the-security-team-now-what
- https://www.drupal.org/drupal-security-team/security-team-procedures/security-issues-on-gitdrupalcodeorg
- https://www.drupal.org/drupal-security-team/security-team-procedures/how-a-security-issue-goes-from-initial-report-to-security-advisory
- https://www.drupal.org/drupal-security-team/security-team-procedures/security-issue-release-process
- https://www.drupal.org/drupal-security-team/security-advisory-process-and-permissions-policy
- https://www.drupal.org/drupal-security-team/security-release-numbers-and-release-timing

## Confidentiality

The issue stays confidential until the SA is published. Its content is shared
only in the private work item, with the security team and the project's
co-maintainers.

- Code goes only to the issue's private fork on git.drupalcode.org. The
  canonical project repository and its public merge requests stay untouched
  until the security team gives the go-ahead.
- Commit messages are neutral: they describe the change without naming
  security, a vulnerability or an exploit, as in "Fixed sanitization of output
  in overview table."
- Tests that would reveal how to exploit the issue are committed later, after
  the SA (core waits two months). Ask the security team when unsure.

## Eligibility

An SA is only issued when all of these hold. Otherwise the issue is fixed in the
public issue queue.

- The project is opted into security advisory coverage.
- A stable release of a supported branch is affected. Dev, alpha, beta and RC
  releases are not covered.
- The code is hosted on drupal.org. External libraries are not covered, unless
  bundled with core.
- Exploiting it needs no advanced permission: a permission with
  `restrict access: true`, or one to administer users, permissions, modules,
  site configuration or views, or to access site reports.

## Stages

1. **Report.** A confidential work item is created in the `security` group on
   git.drupalcode.org, titled with the project's machine name, such as
   `token: access bypass in ...`. Automation creates a private fork, adds
   labels and posts instructions. Maintainers are granted access with a comment
   line `/access @gitlab-username`.
2. **Validate.** The maintainer confirms the vulnerability, asks the reporter
   for details when needed, and checks the project for similar
   vulnerabilities. Progress on the code must show within **2 weeks** of first
   contact, or the team may mark the project unsupported and publish an SA
   telling users to uninstall it.
3. **Fix.** One branch and merge request per vulnerable supported branch, all
   in the private fork:
   ```
   git remote add security <private-fork-url>
   git checkout -b 2.x-security origin/2.x
   git push security 2.x-security
   ```
   Each merge request targets the private fork, never the public project, and
   references the work item. The security team reviews it.
4. **Advisory.** The comment `/label ~"Security advisory::needed"` makes
   drupalbot post a link to a prefilled SA draft form. Saving the draft adds
   the `Security advisory::drafted` label. The maintainer posts the SA link in
   the work item; the team reviews it and asks the maintainer to pick a release
   Wednesday.
5. **Release.** On the agreed Tuesday after 17:00 UTC, or within 24 hours
   before the window, the maintainer downloads each merge request as a plain
   diff (append `.diff` to its URL), applies it with `git apply` to a clone of
   the canonical repository, commits with a neutral message, pushes, tags, and
   creates a release node with release type "Security update". The release
   node stays unpublished. The maintainer links the release in the SA and
   comments in the work item that the release is done.
6. **Publish.** The security team publishes the releases and the SA on
   Wednesday between 16:00 and 22:00 UTC, assigns the CVE, and fills in
   "Fixed in" and "Affected versions". A missed window is rescheduled in the
   work item; nothing is pushed until then.

A security release is a normal release with the next version number; nothing in
the version marks it as a security release.
