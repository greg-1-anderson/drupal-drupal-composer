#!/bin/bash

VERSION_CONSTRAINT="${1:-8.8.x-dev}"

composer remove --dev --no-update greg-1-anderson/core-recommended-dev-dependencies
composer require --dev "greg-1-anderson/core-dev-dependencies:$VERSION_CONSTRAINT"
composer update --lock
