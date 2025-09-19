#!/bin/bash

# Check if jemalloc is available and set LD_PRELOAD accordingly

echo "* Running as user: $(whoami)"
echo "* Working directory: $(pwd)"

echo "* SQL MIGRATING"
bundle exec rake db:migrate

exec "$@"
