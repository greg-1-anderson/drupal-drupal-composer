#!/bin/bash

VERSION_CONSTRAINT="${1:-8.8.x-dev}"

set -ex

# Test to see what works (unimportant operations)
composer update --lock
composer update

# Remove, relax, and update the lockfile's content hash
composer remove --dev --no-update greg-1-anderson/core-recommended-dev-dependencies
composer require --dev "greg-1-anderson/core-dev-dependencies:$VERSION_CONSTRAINT"
composer update --lock
