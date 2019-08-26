#!/bin/bash

WORK_DIR="${1:-/tmp}"

# If running on Mac, it is necessary to install gnu sed via:
#   brew install gnu-sed
if [ -f "/usr/local/opt/gnu-sed/libexec/gnubin/sed" ] ; then
  PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
fi

# Clean up some work directories
rm -rf $WORK_DIR/drupal-drupal-composer
rm -rf $WORK_DIR/drupal-untarred
rm -rf $WORK_DIR/package-metadata


# Set up our own packages.json metadata project
mkdir $WORK_DIR/package-metadata
cp composer.json composer.lock $WORK_DIR/package-metadata
git -C $WORK_DIR/package-metadata init
git -C $WORK_DIR/package-metadata add -A .
git -C $WORK_DIR/package-metadata commit -m 'Initial commit'
echo "{ \"package\": { \"name\": \"greg-1-anderson/drupal-drupal-composer\", \"version\": \"1.0.0\", \"source\": { \"url\": \"$WORK_DIR/package-metadata/.git\", \"type\": \"git\", \"reference\": \"master\" } } }" > $WORK_DIR/packages.json

# Use 'composer create-project' to create our SUT
composer create-project -n --repository-url=$WORK_DIR/packages.json greg-1-anderson/drupal-drupal-composer $WORK_DIR/drupal-drupal-composer
composer -n --working-dir=$WORK_DIR/drupal-drupal-composer composer:scaffold

# Look up the version of drupal/core in our SUT, and use it to download a tarball
DRUPAL_CORE_VERSION=$(composer --working-dir=$WORK_DIR/drupal-drupal-composer show drupal/core | grep 'versions' | grep -o -E '\*\ .+' | cut -d' ' -f2 | cut -d',' -f1;)
echo "Drupal core version is $DRUPAL_CORE_VERSION"
curl -o $WORK_DIR/drupal.tgz https://ftp.drupal.org/files/projects/drupal-$DRUPAL_CORE_VERSION.tar.gz
ls $WORK_DIR
cd $WORK_DIR
tar -xzvf drupal.tgz >/dev/null 2>&1
mv drupal-$DRUPAL_CORE_VERSION drupal-untarred

# Repair the tarball:
#  - Remove info from drupal.org packaging from info.yml files
#  - Remove the "composer" directory
#  - Remove the 'test' directory in mikey179/vfsstream which Vendor Hardening removes, but the tarball does not
find $WORK_DIR/drupal-untarred -name "*.info.yml" -exec sed -e 's/^# version:/version:/' -e 's/^# core:/core:/' -e '/# Information added by Drupal.org packaging script/,$d' -i {} \;
rm -rf $WORK_DIR/drupal-untarred/composer
rm -rf $WORK_DIR/drupal-untarred/vendor/mikey179/vfsstream/src/test

# Extra files that exist in the SUT that are not present in the tarball.
# Not sure why some of these are present, but these are not significant, so
# it does not matter. We'll just remove them here to get a clean diff.
# (Relates to .gitattributes export stripping.)
rm -rf $WORK_DIR/drupal-drupal-composer/vendor/behat/mink/CONTRIBUTING.md
rm -rf $WORK_DIR/drupal-drupal-composer/vendor/behat/mink/.gitattributes
rm -rf $WORK_DIR/drupal-drupal-composer/vendor/behat/mink/.gitignore
rm -rf $WORK_DIR/drupal-drupal-composer/vendor/behat/mink/phpdoc.ini.dist
rm -rf $WORK_DIR/drupal-drupal-composer/vendor/behat/mink/phpunit.xml.dist
rm -rf $WORK_DIR/drupal-drupal-composer/vendor/behat/mink/.travis.yml

set -ex

# Check for differences between the tarball and the SUT (except vendor)
diff -rBq \
  -x .git \
  -x .gitignore \
  -x vendor \
  -x autoload.php \
  -x LICENSE.txt \
  -x composer.json \
  -x composer.lock \
  $WORK_DIR/drupal-untarred $WORK_DIR/drupal-drupal-composer

# Check for differences between the vendor directory in the tarball and the SUT
diff -rBq \
  -x .git \
  -x .htaccess \
  -x autoload.php \
  -x web.config \
  -x composer \
  -x drupalcs.info \
  -x core-composer-scaffold \
  -x core-vendor-hardening \
  $WORK_DIR/drupal-untarred/vendor $WORK_DIR/drupal-drupal-composer/vendor
