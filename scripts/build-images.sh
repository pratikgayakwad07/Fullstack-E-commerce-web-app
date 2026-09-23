#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${ROOT_DIR}"

echo "=========================================="
echo " Building Docker Images for Local K8s"
echo "=========================================="

images=(
    "purely/service-registry:latest:microservice-backend/service-registry"
    "purely/api-gateway:latest:microservice-backend/api-gateway"
    "purely/auth-service:latest:microservice-backend/auth-service"
    "purely/category-service:latest:microservice-backend/category-service"
    "purely/product-service:latest:microservice-backend/product-service"
    "purely/cart-service:latest:microservice-backend/cart-service"
    "purely/order-service:latest:microservice-backend/order-service"
    "purely/user-service:latest:microservice-backend/user-service"
    "purely/notification-service:latest:microservice-backend/notification-service"
    "purely/web-app:latest:frontend"
)

total=${#images[@]}
count=0

for item in "${images[@]}"; do
    IFS=":" read -r name path <<< "${item}"
    count=$((count + 1))
    echo ""
    echo "[$count/$total] Building image: ${name}..."
    docker build -t "${name}" -f "${path}/Dockerfile" "${path}"
done

echo ""
echo "=========================================="
echo " All images built successfully!"
echo "=========================================="

if command -v minikube &> /dev/null; then
    echo "Tip: If using Minikube, load images using:"
    echo "  minikube image load purely/service-registry:latest purely/api-gateway:latest purely/auth-service:latest purely/category-service:latest purely/product-service:latest purely/cart-service:latest purely/order-service:latest purely/user-service:latest purely/notification-service:latest purely/web-app:latest"
fi
if command -v kind &> /dev/null; then
    echo "Tip: If using Kind, load images using:"
    echo "  kind load docker-image purely/service-registry:latest purely/api-gateway:latest purely/auth-service:latest purely/category-service:latest purely/product-service:latest purely/cart-service:latest purely/order-service:latest purely/user-service:latest purely/notification-service:latest purely/web-app:latest"
fi
