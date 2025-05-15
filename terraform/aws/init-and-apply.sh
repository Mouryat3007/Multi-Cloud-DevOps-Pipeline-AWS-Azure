#!/bin/bash
set -e

cd "$(dirname "$0")"

echo "Initializing Terraform for AWS..."
terraform init

echo "Applying Terraform for AWS..."
terraform apply -auto-approve

