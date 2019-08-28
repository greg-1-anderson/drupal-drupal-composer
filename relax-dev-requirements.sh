#!/bin/bash

VERSION_CONSTRAINT="${1:-8.8.x-dev}"

composer remove --dev --no-update drupal/pinned-dev-dependencies
composer require --dev "drupal/dev-dependencies:$VERSION_CONSTRAINT"
composer update --lock
