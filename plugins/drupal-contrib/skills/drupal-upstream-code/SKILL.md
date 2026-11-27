---
name: drupal-upstream-code
description: Writes code, comments and tests for Drupal core or a drupal.org contrib project in the form Drupal core uses. Use when writing or changing code in a core or contrib checkout, such as an issue fork.
---

# Write code for Drupal core and contrib

Drupal core is the reference for code that goes to drupal.org. Its coding
standards and its code base show the form of every construct, and maintainers
review against them. A team's house style, such as a conventions skill for its
own sites, does not apply here.

## Find the precedent

Everything you write takes the form core uses most. Code idioms, designs,
comments, docblocks, tags, labels, messages, terms and spelling (US English) are
examples, not the full list. For each, look up the problem in
[core-forms.md](core-forms.md) first, and use a listed form as it is, without
recounting it, unless the core version in use is higher than the entry's: then
recount it with the entry's command and scope. For a problem not listed, check
the written standards first. Only when they are silent, find how core
(`web/core` in a ddev-drupal-contrib site) solves the same problem, count the
forms it uses, and copy the one in the majority. Core 11.4 declares 9565 methods
`protected` and 485 `private`: `private` exists in core, but it is the minority
and not core's form, so methods and properties are `protected`. Start from the
problem, not from a construct already chosen: a form found once, or only in
`@internal` or test code, is not core practice. When core has no precedent, ask
the developer.

Code for a contrib project serves any site: a rule, default or integration taken
from the site that commissioned it becomes an option, off by default, or stays
out.

The written standards: https://project.pages.drupalcode.org/coding_standards/

## Scope of the change

Maintainers review against Drupal's
[issue scope guidelines](https://www.drupal.org/core/scope): "Each issue should
fix only one problem", in "the simplest way possible". Code the issue does not
need stays as it is: existing code is not moved into a shared trait or helper. A
few lines used in one place stay at that place, without a helper, trait or class
around them. Other improvements go in a follow-up issue, filed with
`drupal-contrib:issue-queue`.

## Report the precedents

With the change, give the developer the precedent report: one line for each
construct in the diff, code and comments alike, that names the `core-forms.md`
entry, the written standard, or the core file and line that settles it. A
problem that `core-forms.md` does not list, or an entry recounted for a newer
core version, comes with the entry in that file's format: form, standard, count
with the core version, and command. `core-forms.md` is part of this plugin, not
of the project, so the entry is a change to the plugin's repository, which the
developer takes there. The report goes in neither the commit nor the merge
request.

## Comment forms core uses

- An explanation of a code block sits on the lines directly before that block;
  the method docblock describes the method as a whole.
- A comment on a code block opens with what the block does, in the imperative,
  and the reason follows, such as "Check that the URL is well formed, starting
  with 'scheme://', where 'scheme' is a database driver name." in
  `core/lib/Drupal/Core/Database/Database.php`.
- A comment describes the code as it is; what the change replaced belongs in the
  issue, not in the code.
- A class or method reference is an `@see` line with the fully qualified name,
  on its own line below the comment it supports, as in
  `core/modules/dynamic_page_cache/src/EventSubscriber/DynamicPageCacheSubscriber.php`.
- A drupal.org issue is cited by its full URL, such as
  `https://www.drupal.org/node/2950883`.
- A number in prose names what it is, such as "Run after
  HtmlResponsePlaceholderStrategySubscriber (priority 5)" in
  `core/modules/big_pipe/src/EventSubscriber/HtmlResponseBigPipeSubscriber.php`.
- An existing `@todo` or comment is a claim about the code: check it against the
  current code and the supported core versions before reusing its wording.
