---
name: install-site
description: Installs Drupal, with Drush, in a contrib checkout that has a ddev-drupal-contrib setup, and enables the project. Use when a task needs the local site in a browser or needs Drush, and the site is not installed yet.
---

# Install the site in a ddev-drupal-contrib checkout

The checkout has a ddev-drupal-contrib setup: `.ddev/config.contrib.yaml`
exists and `ddev poser` has run. Without one, set it up first with
`drupal-contrib:ddev-drupal-contrib`. As there, nothing the project tracks
changes in the end.

## Before you start

- `git diff --quiet composer.json` succeeds: step 1 restores `composer.json`
  from git, which would discard local changes to it.
- When `ddev drush status --field=bootstrap` prints `Successful`, the site is
  already installed. Keep it and skip step 2: a new install wipes the site.

## Steps

1. Add Drush, when `ddev drush version` fails:

   ```sh
   ddev composer require --dev --no-update --no-plugins drush/drush
   ddev poser
   git checkout -- composer.json
   ```

   The ddev-drupal-contrib README puts Drush in the project's `require-dev`.
   `--no-plugins` keeps Composer from failing on the plugins in `vendor/`,
   which the project's `composer.json` does not allow. `ddev poser` builds its
   temporary `composer.contrib.json` from `composer.json`, so `composer.json`
   needs Drush only while `ddev poser` runs. Every later `ddev poser` removes
   Drush again: repeat this step after it.

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
   - `git status --porcelain` prints nothing.

Done when all three checks pass. `ddev drush user:login` prints a one-time
login link for the browser, and `ddev describe` the site's URL.
