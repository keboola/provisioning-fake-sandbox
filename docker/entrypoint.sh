#!/usr/bin/env bash
set -e

# the tmp folder is a mapped volume so it may possibly be non-empty, so -R is very important
chmod -R a+rw /tmp/
composer get-parameters
exec "$@"
