#!/bin/bash
set -e

# deploy to development
yes | eval $(docker run --rm -i -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY quay.io/keboola/aws-cli ecr get-login --region us-east-1 --no-include-email)
docker tag keboola/provisioning-fake-sandbox:latest 061240556736.dkr.ecr.us-east-1.amazonaws.com/keboola/provisioning-fake-sandbox:${TRAVIS_TAG}
docker tag keboola/provisioning-fake-sandbox:latest 061240556736.dkr.ecr.us-east-1.amazonaws.com/keboola/provisioning-fake-sandbox:latest
docker push 061240556736.dkr.ecr.us-east-1.amazonaws.com/keboola/provisioning-fake-sandbox:${TRAVIS_TAG}
docker push 061240556736.dkr.ecr.us-east-1.amazonaws.com/keboola/provisioning-fake-sandbox:latest
