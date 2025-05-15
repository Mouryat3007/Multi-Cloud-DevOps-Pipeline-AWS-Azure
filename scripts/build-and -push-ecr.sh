#!/bin/bash
set -e

AWS_REGION="us-east-1"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
SERVICES=("service-a" "service-b")

for SERVICE in "${SERVICES[@]}"; do
  IMAGE_NAME="$SERVICE"
  ECR_REPO="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME"

  echo "Logging into AWS ECR..."
  aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO

  echo "Building Docker image for $SERVICE"
  docker build -t $IMAGE_NAME ./docker/$SERVICE

  echo "Tagging image for $ECR_REPO"
  docker tag $IMAGE_NAME:latest $ECR_REPO:latest

  echo "Pushing $IMAGE_NAME to ECR"
  docker push $ECR_REPO:latest

done
