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

For each comment, docblock, tag and code idiom you write, find the same
construct in core (`web/core` in a ddev-drupal-contrib site) and copy its form.
Report the precedent (file and line) with the change. When core has no
precedent, ask the developer.

The written standards:
https://www.drupal.org/docs/develop/standards/php/api-documentation-and-comment-standards

## Comment forms core uses

- An explanation of a code block sits on the lines directly before that block;
  the method docblock describes the method as a whole.
- A class or method reference is an `@see` line with the fully qualified name,
  on its own line below the comment it supports, as in
  `core/modules/dynamic_page_cache/src/EventSubscriber/DynamicPageCacheSubscriber.php`.
- A drupal.org issue is cited by its full URL, such as
  `https://www.drupal.org/node/2950883`.
- A number in prose names what it is, such as "Run after
  HtmlResponsePlaceholderStrategySubscriber (priority 5)" in
  `core/modules/big_pipe/src/EventSubscriber/HtmlResponseBigPipeSubscriber.php`.
- An existing `@todo` or comment is a claim about the code: check it against
  the current code and the supported core versions before reusing its wording.
