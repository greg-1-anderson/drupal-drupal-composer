# Drupal-Drupal-Composer

THIS IS A DEMONSTRATION AND WILL NOT BE MAINTAINED. DO NOT USE.

This is a project template for Drupal 8 projects with composer following the drupal/drupal layout. The goal of this project is to try out various things prior to making a similar patch in Drupal Core.

This project is based on drupal-composer/drupal-project, except it does not have a relocated document root. The Drupal root is installed at the project root, just like the drupal/drupal project. The intention is that this layout will be used by the Drupal.org infrastructure to create the Drupal tarballs for download. The benefit of doing it this way is that users will be able to take ownership of the `composer.json` file at the project root. Immediately after untaring Drupal, `composer require` may be used to add modules and themes to Drupal, and `composer update` may be used in the future to update Drupal Core, and the site's contrib modules.

## Usage

```
$ git clone git@github.com:greg-1-anderson/drupal-drupal-composer.git
$ cd drupal-drupal-composer
$ composer install
$ ./vendor/bin/drush si --db-url=mysql://root@127.0.0.1/exampledb --site-name=Example
```

## Enhancements over drupal-composer/drupal-scaffold

This project is using the [experimental 8.8.x branch of drupal/drupal-scaffold](https://github.com/drupal/drupal-scaffold/tree/8.8.x). This project is based on [drupal-composer/drupal-scaffold](https://github.com/drupal-composer/drupal-scaffold), but with a coupld of enhancements.

- Instead of encoding the list of scaffold files in the scaffold tool, or the root project's composer.json file, individual dependencies (e.g. drupal/core) may declare the scaffold files that should be placed, and where they should go in the target site.  
- Instead of downloading each scaffold file individually from drupal.org, files are copied from the project that contains them. This should significantly reduce the load placed on drupal.org when a new Drupal version comes out.
- Scaffold files may now be prepended or appended to via directives in profiles (which may also provide scaffold files) or the top-level project composer.json file.

## Feature comparison with drupal-composer/drupal-project

In addition to creating the minimum-viable installable Drupal site, drupal-composer/drupal-project also provides additional services for sites that are based on it.

Items checked below are also supported in this project.

- [x] Create modules, profiles and themes directories.
- [ ] _Create an initial settings.php file._
- [ ] _Include and configure cweagans/composer-patches._
- [ ] _Include Drush and Drupal Console._
- [ ] Create an initial files directory.
- [ ] Custom environment variable definition via .env files using vlucas/phpdotenv.
- [ ] Include example Drush configuration files.
- [ ] ~Create a random config sync directory name prior to installing.~
- [ ] ~Ensure that Composer is at version 1.0.0 or later.~

The unchecked items are potential TODOs for this project, or a derivative project. The items in italic were provided at one time, but backed out to make the results of this project more in line with a drupal/drupal tarball. The items that have been struck out, though, are probably not necessary to maintain.
