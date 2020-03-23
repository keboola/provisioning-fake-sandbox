#!/usr/bin/env bash
set -Eeuo pipefail

# push to ACR
docker tag keboola/provisioning-fake-sandbox:latest $AZURE_REPOSITORY:${TRAVIS_TAG}
docker tag keboola/provisioning-fake-sandbox:latest $AZURE_REPOSITORY:latest

docker run --volume /var/run/docker.sock:/var/run/docker.sock quay.io/keboola/azure-cli sh -c "az login --service-principal -u $AZURE_SERVICE_PRINCIPAL -p $AZURE_SERVICE_PRINCIPAL_PASSWORD --tenant $AZURE_SERVICE_PRINCIPAL_TENANT && az acr login --resource-group $AZURE_RESOURCE_GROUP --name $AZURE_REGISTRY_NAME && docker push $AZURE_REPOSITORY:latest && docker push $AZURE_REPOSITORY:$TRAVIS_TAG"
