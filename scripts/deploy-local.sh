#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${ROOT_DIR}"

echo "=========================================="
echo " Deploying Purely App to Local Kubernetes"
echo "=========================================="

echo ""
echo "[1/6] Checking Kubernetes cluster connection..."
kubectl cluster-info

echo ""
echo "[2/6] Creating namespace..."
kubectl apply -f k8s-local/00-namespace.yaml

echo ""
echo "[3/6] Deploying in-cluster MongoDB & seeding data..."
kubectl apply -f k8s-local/01-mongodb.yaml
echo "Waiting for MongoDB pod to be ready..."
kubectl wait --namespace purely --for=condition=ready pod -l app=mongodb --timeout=90s

echo ""
echo "[4/6] Deploying Eureka Service Registry..."
kubectl apply -f k8s-local/02-service-registry.yaml
echo "Waiting for Service Registry pod to be ready..."
kubectl wait --namespace purely --for=condition=ready pod -l app=registry --timeout=120s

echo ""
echo "[5/6] Deploying ConfigMaps, Secrets, Microservices, API Gateway, and Frontend..."
kubectl apply -f k8s-local/03-config-and-secrets.yaml
kubectl apply -f k8s-local/04-backend-services.yaml
kubectl apply -f k8s-local/05-api-gateway.yaml
kubectl apply -f k8s-local/06-frontend.yaml
kubectl apply -f k8s-local/07-ingress.yaml || true

echo ""
echo "[6/6] Waiting for all microservices to start..."
sleep 5
kubectl get pods -n purely

echo ""
echo "=========================================="
echo " Deployment applied successfully!"
echo "=========================================="
echo ""
echo "To check status anytime:"
echo "  kubectl get pods -n purely"
echo ""
echo "To access the application:"
echo "  1. Direct NodePort URL (Docker Desktop / Kind / Minikube):"
echo "     http://localhost:30080"
echo "  2. Or run the Port-Forward helper script:"
echo "     ./scripts/port-forward.sh"
echo "     - Frontend:         http://localhost:3000"
echo "     - Eureka Dashboard: http://localhost:8761"
echo "     - API Gateway:      http://localhost:8080"
