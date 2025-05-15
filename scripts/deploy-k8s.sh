#!/bin/bash
set -e

CLOUD="$1"

if [[ "$CLOUD" != "aws" && "$CLOUD" != "azure" ]]; then
  echo "Usage: $0 <aws|azure>"
  exit 1
fi

K8S_DIR="./k8s/$CLOUD"

if [ ! -d "$K8S_DIR" ]; then
  echo "Kubernetes manifest directory '$K8S_DIR' not found!"
  exit 1
fi

echo "Deploying to $CLOUD Kubernetes cluster..."
kubectl apply -f $K8S_DIR
