---
name: ddev-drupal-contrib
description: Sets up a local DDEV site for a checkout of a Drupal contrib module or theme, such as a drupal.org issue fork, with the ddev-drupal-contrib add-on, keeping every file it creates out of the project's repository. Use when starting work on a contrib project checkout that has no local site yet, or when asked to set up ddev-drupal-contrib.
---

# Set up ddev-drupal-contrib in a contrib checkout

The project belongs to its maintainers, who choose their own tooling. The site
is local to this machine: nothing it creates is committed, and no file the
project tracks is changed.

## Before you start

- The working tree is clean (`git status --porcelain` prints nothing), so that
  every untracked file afterwards is a setup artifact.
- If the project tracks a `.ddev/` directory, its maintainers use DDEV: keep
  their configuration, skip step 1 and leave `/.ddev/` out of step 2. Put local
  changes in `.ddev/config.local.yaml`, which DDEV ignores.
- Name the DDEV project after the module's machine name: `symlink-project`
  names the module's directory under `web/modules/custom/` after it.

## Steps

1. Configure DDEV and add the add-on:

   ```sh
   ddev config --project-type=drupal11 --docroot=web --project-name=<machine_name>
   ddev add-on get ddev/ddev-drupal-contrib
   ```

2. Exclude the setup files locally, in `.git/info/exclude`, which every
   worktree of the clone shares:

   ```sh
   printf '%s\n' '# ddev-drupal-contrib' /.ddev/ /web/ /vendor/ /recipes/ \
     /.editorconfig /.gitattributes /.gitignore \
     >> "$(git rev-parse --git-common-dir)/info/exclude"
   ```

   `ddev poser` scaffolds core's `.editorconfig`, `.gitattributes` and
   `recipes/` into the checkout root, and `ddev symlink-project` writes a
   `.gitignore` when the project has none. Leave out any of these paths the
   project tracks; an exclude has no effect on tracked files.

3. Build the site:

   ```sh
   ddev start
   ddev poser
   ddev symlink-project
   ddev config --update
   ddev restart
   ```

   `ddev poser` installs the project's `require-dev` along with core, through a
   temporary `composer.contrib.json` that it removes afterwards.
   `ddev config --update` sets the PHP version that matches the installed core.

4. Verify:
   - `git status --porcelain` prints nothing. A tracked file listed as modified
     was overwritten by core scaffolding: restore it with
     `git checkout -- <file>`.
   - A test of the project passes, e.g. `ddev phpunit tests/src/Kernel`, with
     the path relative to the checkout root.

## Never

- Commit or push a setup file, or add one to the project's `.gitignore`.
- Add dependencies to the project's `composer.json` for the local site.
- Change the project's CI, PHPUnit, PHPCS or PHPStan configuration to suit the
  local site.
