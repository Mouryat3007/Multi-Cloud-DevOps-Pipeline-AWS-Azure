#!/bin/bash
set -e

ACR_NAME="myacr"
RESOURCE_GROUP="myResourceGroup"
SERVICES=("service-a" "service-b")

ACR_LOGIN_SERVER=$(az acr show --name $ACR_NAME --resource-group $RESOURCE_GROUP --query loginServer --output tsv)

for SERVICE in "${SERVICES[@]}"; do
  echo "Logging into Azure ACR..."
  az acr login --name $ACR_NAME

  echo "Building Docker image for $SERVICE"
  docker build -t $SERVICE ./docker/$SERVICE

  echo "Tagging image for $ACR_LOGIN_SERVER"
  docker tag $SERVICE:latest $ACR_LOGIN_SERVER/$SERVICE:latest

  echo "Pushing $SERVICE to ACR"
  docker push $ACR_LOGIN_SERVER/$SERVICE:latest

done
