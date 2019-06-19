# Drupal-Drupal-Composer

[![Build Status](https://travis-ci.org/greg-1-anderson/drupal-drupal-composer.svg?branch=master)](https://travis-ci.org/greg-1-anderson/drupal-drupal-composer)

THIS IS A DEMONSTRATION AND WILL NOT BE MAINTAINED. DO NOT USE.

This is a project template for Drupal 8 projects with composer following the drupal/drupal layout. The goal of this project is to try out various things prior to making a patch with similar behavior for Drupal Core.

This project is based on drupal-composer/drupal-project, except it does not have a relocated document root. The Drupal root is installed at the project root, just like the drupal/drupal project. The intention is that this layout will be used by the Drupal.org infrastructure to create the Drupal tarballs for download. The benefit of doing it this way is that users will be able to take ownership of the `composer.json` file at the project root. Immediately after untaring Drupal, `composer require` may be used to add modules and themes to Drupal, and `composer update` may be used in the future to update Drupal Core, and the site's contrib modules.

## Usage

```
$ git clone git@github.com:greg-1-anderson/drupal-drupal-composer.git
$ cd drupal-drupal-composer
$ composer install
$ composer composer:scaffold
$ ./vendor/bin/drush si --db-url=mysql://root@127.0.0.1/exampledb --site-name=Example
```

Note that `composer install` should run the scaffold operation, but currently does not due to a bug in drupal/drupal-scaffold.

## Feature comparison with drupal-composer/drupal-project

This project is using the [experimental 8.8.x branch of drupal/drupal-scaffold](https://github.com/drupal/drupal-scaffold/tree/8.8.x). This project is based on [drupal-composer/drupal-scaffold](https://github.com/drupal-composer/drupal-scaffold), but with some additions and removals.

### New Features

- Instead of encoding the list of scaffold files in the scaffold tool, or the root project's composer.json file, individual dependencies (e.g. drupal/core) may declare the scaffold files that should be placed, and where they should go in the target site.  
- Instead of downloading each scaffold file individually from drupal.org, files are copied from the project that contains them. This should significantly reduce the load placed on drupal.org when a new Drupal version comes out.
- Scaffold files may now be prepended or appended to via directives in profiles (which may also provide scaffold files) or the top-level project composer.json file.

### Feature Comparison

- [x] Create modules, profiles and themes directories.
- [ ] _Create an initial settings.php file._
- [ ] _Include and configure cweagans/composer-patches._
- [ ] _Include Drush and Drupal Console._
- [ ] Create an initial files directory.
- [ ] Custom environment variable definition via .env files using vlucas/phpdotenv.
- [ ] Include example Drush configuration files.
- [ ] ~Create a random config sync directory name prior to installing.~
- [ ] ~Ensure that Composer is at version 1.0.0 or later.~

In the list above, **checked** items are features of drupal-composer/drupal-project also implemented here. _Italic_ items were implemented here in a previous revision, but have been backed out to make the results of this project more in line with a drupal/drupal tarball. Plain text items could be added to this project, or a derivative project. ~Strikethough~ items are probably not necessary.
