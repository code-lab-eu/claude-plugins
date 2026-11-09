---
name: install-site
description: Installs Drupal, with Drush, in a contrib checkout that has a ddev-drupal-contrib setup, enables the project, and adds the contrib modules a task needs. Use when a task needs the local site in a browser, Drush, or another module on the local site.
---

# Install the site in a ddev-drupal-contrib checkout

The checkout has a ddev-drupal-contrib setup: `.ddev/config.contrib.yaml`
exists and `ddev poser` has run. Without one, set it up first with
`drupal-contrib:ddev-drupal-contrib`. As there, nothing the project tracks
changes in the end.

## Before you start

- `git diff --quiet composer.json` succeeds: adding a package restores
  `composer.json` from git, which would discard local changes to it.
- When `ddev drush status --field=bootstrap` prints `Successful`, the site is
  already installed. Keep it and skip step 2: a new install wipes the site.

## Steps

1. Add Drush, when `ddev drush version` fails, as described under
   [Add packages](#add-packages).
2. Install Drupal with the standard profile, and enable the project (a theme
   with `theme:install`):

   ```sh
   ddev drush site:install standard --yes
   ddev drush pm:install <machine_name> --yes
   ```

3. Verify:
   - `ddev drush status --field=bootstrap` prints `Successful`.
   - `ddev drush pm:list --status=enabled --filter=<machine_name>` lists the
     project.
   - `git status --porcelain` lists no file that it did not list before the
     install.

Done when all three checks pass. `ddev drush user:login` prints a one-time
login link for the browser, and `ddev describe` the site's URL.

## Add packages

Drush and any contrib module the local site needs, such as one the project
integrates with, go in as development dependencies:

```sh
ddev composer require --dev --no-update --no-plugins \
  'drush/drush:^13' '<package>:<constraint>'...
ddev poser
git checkout -- composer.json
ddev drush pm:install <module>... --yes
```

The ddev-drupal-contrib README puts such packages in the project's
`require-dev`. `ddev poser` builds its temporary `composer.contrib.json` from
`composer.json`, so `composer.json` needs them only while `ddev poser` runs.
`--no-plugins` keeps Composer from failing on the plugins in `vendor/`, which
the project's `composer.json` does not allow. With `--no-update`, a package
without a version constraint can resolve to a development release: give each
one the constraint of its latest stable release.

Each `ddev poser` installs only what `composer.json` lists at that moment, and
removes every package added before. Name Drush and every package added
earlier in each `ddev composer require`.

Verify with `git status --porcelain`, which lists no file that it did not list
before, and `ddev drush pm:list --status=enabled --filter=<module>`, which
lists each module.
