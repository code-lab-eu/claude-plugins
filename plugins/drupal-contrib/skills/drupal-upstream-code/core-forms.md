# Counted core forms

Each entry settles one problem: the form to use, the written standard that
settles it, or else the count in core that does. Use a listed form as it is.
Recount it only when the core version in use is higher than the entry's, with
the entry's command and scope, and give the updated entry in the precedent
report.

### Order of `@internal` and `@see` in a method docblock

- Form: `@internal` first, as in
  `core/lib/Drupal/Core/Routing/UrlGenerator.php:441-443` and
  `core/lib/Drupal/Core/Database/Connection.php:1393-1397` (blank line between
  the tags).
- Standard: none; the order of documentation sections in
  https://project.pages.drupalcode.org/coding_standards/php/documentation/#order-of-documentation-sections
  does not list `@internal`.
- Count: 20 to 10, core 11.4, method docblocks (functions in a class, interface,
  trait or enum) that carry both tags, test code excluded; 5 of the 10 are in
  `core/lib/Drupal/Core/Database/StatementIteratorTrait.php`. Functions outside
  a class have no majority (2 to 3).
- Command: PHP tokenizer probe over the docblocks directly before a function;
  the probe was not kept.

### Static method passed as the callback of `array_map()`

- Form: `[X::class, 'method']`, as in
  `core/modules/layout_builder/src/Section.php:388` and
  `core/modules/layout_builder/src/Entity/LayoutBuilderEntityViewDisplayStorage.php:38`.
- Standard: none; the API documentation standards do not cover callable syntax.
- Count: 10 to 9 string `'\X::method'` and 1 first-class callable
  (`core/modules/package_manager/src/ComposerInspector.php:330`), core 11.4,
  test code excluded.
- Command: not recorded.

### Message of a deprecated optional argument that becomes required

- Form:
  `Calling X() without the $y argument is deprecated in drupal:A and it will be required in drupal:B. See https://www.drupal.org/node/N`,
  as in `core/modules/editor/src/EditorController.php:18` and
  `core/modules/editor/src/Element.php:25`.
- Standard: not checked; the deprecation how-to page on drupal.org returned 404
  (2026-11-26).
- Count: 39 "and it will be required in", 19 "and will be required in", 1 "and
  the argument will be required in", 1 "and is required in" (4 "and it will
  throw an error in" are a different case), core 11.4.13.
- Command:
  `grep -rhoE "argument is deprecated in drupal:[0-9.]+ and [a-z ]+ in" web/core --include=*.php | sed -E 's/[0-9.]+//' | sort | uniq -c`
