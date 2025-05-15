#!/bin/bash

set -e

echo "Initializing Terraform for AWS..."

terraform init

echo "Applying Terraform configuration..."

terraform apply -auto-approve \
  -var="aws_region=${AWS_REGION}" \
  -var="cluster_name=${CLUSTER_NAME}"

echo "Terraform apply completed."
