#!/bin/bash
set -e

echo "Initializing Terraform for AWS..."
terraform init

echo "Planning Terraform changes..."
terraform plan

echo "Applying Terraform changes..."
terraform apply -auto-approve
