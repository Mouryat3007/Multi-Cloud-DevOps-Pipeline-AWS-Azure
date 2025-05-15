#!/bin/bash
set -e

echo "Initializing Terraform for AWS..."

# Move to the terraform directory where the .tf files are
cd "$(dirname "$0")"

terraform init

echo "Applying Terraform configuration..."

terraform apply -auto-approve \
  -var="aws_region=${AWS_REGION}" \
  -var="cluster_name=${CLUSTER_NAME}"

echo "Terraform apply completed."
