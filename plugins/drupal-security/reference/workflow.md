# Drupal security issue workflow

How a vulnerability reported in a drupal.org contrib project goes from the
private report to a published security advisory (SA), from the maintainer's
side. Drupal core follows its own release procedures, which this plugin does
not cover.

Volunteers report vulnerabilities through a private process; the Security Team
manages the reports and guides the maintainer through the fix, the advisory and
the release.

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
- Tests are committed with the fix, so that the vulnerability does not come
  back. The security team's guidance,
  [Contacted by the security team, now what?](https://www.drupal.org/drupal-security-team/contacted-by-the-security-team-now-what),
  is to commit a test a few weeks after the release when it gives away how to
  develop an exploit. The fix itself usually shows that, so this applies only
  when the test reveals what the fix does not, such as a crafted payload or a
  hard-to-find precondition. When in doubt, ask in the work item.

## AI disclosure

drupal.org's
[AI policy](https://www.drupal.org/docs/develop/issues/issue-procedures-and-etiquette/policy-on-the-use-of-ai-when-contributing-to-drupal)
requires a human-written statement at the end of every comment and merge
request description that AI helped write. End each one drafted for the
maintainer with this placeholder, and post it only after the maintainer has
replaced it with their own words:

```
AI disclosure: <write what AI was used for>
```

## Environment

The skills that work on code run in a clone of the work item's private fork
that has the fork as its only git remote, so that nothing can be pushed to the
public project or its issue forks by mistake. The developer makes the clone, as
drupalbot's first comment in the work item instructs:

```
git clone git@git.drupal.org:security/<nid>-<machine_name>-security.git
```

Before working on code, check with `git remote -v` that the private fork is the
only remote. When it is not, stop and give the developer the clone command.

Before working on code, `git status --porcelain` prints nothing, so that every
change belongs to the work. When it lists a file, stop and show the list to the
developer; personal files belong in `.git/info/exclude`. The failing test that
validation leaves for the fix is the one exception.

The fork's branches are copies from when the report came in, and the public
project moves on. Before working on a branch, compare it with the public one,
after `git fetch origin`:

```
git ls-remote git@git.drupal.org:project/<machine_name>.git refs/heads/<branch>
git rev-parse origin/<branch>
```

When they differ, bring the fork's branch up to date, asking the developer
before the push:

```
git fetch git@git.drupal.org:project/<machine_name>.git <branch>
git push origin FETCH_HEAD:refs/heads/<branch>
```

When the push is refused, the fork's branch has commits of its own: stop and
ask the developer.

Tests run with the project's own tooling. When the clone has no local site yet
and the drupal-contrib plugin is installed, set one up with
`drupal-contrib:ddev-drupal-contrib`, and install Drupal in it with
`drupal-contrib:install-site` when a step needs the site in a browser.

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

1. **Report.** The reporter files a confidential issue titled with the
   project's machine name, such as `token: access bypass in ...`. Automation
   creates a private fork of the project in the `security` group, such as
   `security/185873-scheduler-security` forked from `project/scheduler`, with
   the report as its work item 1, adds labels and posts instructions.
   Maintainers are granted access with a comment line
   `/access @gitlab-username`.
2. **Validate.** The maintainer confirms the vulnerability, asks the reporter
   for details when needed, and checks the project for similar
   vulnerabilities. Progress on the code must show within **2 weeks** of first
   contact, or the team may mark the project unsupported and publish an SA
   telling users to uninstall it.
3. **Fix.** One branch and merge request per vulnerable supported branch, all
   in the private fork, worked on in the clone described under
   [Environment](#environment):
   ```
   git checkout -b 2.x-security origin/2.x
   git push origin 2.x-security
   ```
   Each merge request targets a branch of the private fork, never the public
   project, and references the work item. The security team reviews it.
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

## Finding the work items

A maintainer works on the work items they were granted access to. List the
open ones with:

```
glab api --hostname git.drupalcode.org "groups/security/issues?state=opened"
```

## Labels

The labels of the `security` group on git.drupalcode.org, as listed by
`glab api --hostname git.drupalcode.org "groups/security/labels"`. A label is
set or removed with a comment line such as
`/label ~"Security status::validated"`.

The stages follow the label descriptions in that listing and the label history
of work items (`projects/<id>/issues/1/resource_label_events`). The labels in
Validate are set by the maintainer; a security team member replaces
`Security status::validated` during review.

| Label | Set at |
|---|---|
| `Security status::unvalidated` | Report |
| `Security status::validated`, `Security advisory::needed` | Validate |
| `Security status::needs review`, `::needs work`, `::reviewed & tested` | Fix |
| `Security advisory::drafted` and `Security risk::<level>` (both set by saving the SA draft), `Security status::ready to be published` | Advisory |
| `Security release made` | Release |
| `Security advisory::published` | Publish |
| `Needs maintainer response`, `Needs reporter response`, `Needs security team response`, `Needs attention` | Whenever the issue waits on someone |
| `Security status::not in advisory policy`, `::can be public`, `::evaluating to be public`, `Closed::public` | The issue moves to the public issue queue |
| `Closed::duplicate`, `Closed::invalid` | The report is rejected |
| `Security status::postponed` | The fix is put on hold |
| `Project to be unsupported`, `Closed::unsupported` | The maintainer misses the deadline |
| `D7::affected`, `D7::n/a`, `D7::needs evaluation`, `D7::only` | Drupal 7 branches are evaluated |

`Security risk::<level>` is one of `Not critical`, `Less critical`,
`Moderately critical`, `Critical` and `Highly critical`; see
[`risk-levels.md`](risk-levels.md).
