#!/usr/bin/env bash
set -e 
php --version

# when run with 'no-reporter' arguement, the codeclimate reporter is skipped
ARG1=${1:-reporter}

echo "Starting tests" >&1
if [ $ARG1 != "no-reporter" ]; then
	curl -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 > ./cc-test-reporter
	chmod +x ./cc-test-reporter
	./cc-test-reporter before-build
fi
composer get-parameters
composer ci
if [ $ARG1 != "no-reporter" ]; then
	./cc-test-reporter after-build --exit-code 0 --debug
fi

echo "Tests Finished" >&1