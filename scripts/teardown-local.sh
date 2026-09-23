#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${ROOT_DIR}"

echo "=========================================="
echo " Teardown Purely Local Kubernetes Resources"
echo "=========================================="
echo ""
echo "Deleting namespace 'purely' and all associated resources..."
kubectl delete namespace purely --ignore-not-found=true

echo ""
echo "=========================================="
echo " Cleanup complete!"
echo "=========================================="
