# ==============================================================================
# Deploy Fullstack E-Commerce to Local Kubernetes
# ==============================================================================
$ErrorActionPreference = "Stop"

$RootDir = Split-Path -Parent $PSScriptRoot
Set-Location $RootDir

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " Deploying Purely App to Local Kubernetes" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# 1. Check cluster connectivity
Write-Host "`n[1/6] Checking Kubernetes cluster connection..." -ForegroundColor Yellow
try {
    kubectl cluster-info
} catch {
    Write-Host "Failed to connect to Kubernetes cluster! Make sure Docker Desktop Kubernetes / Minikube / Kind is running." -ForegroundColor Red
    exit 1
}

# 2. Apply Namespace
Write-Host "`n[2/6] Creating namespace..." -ForegroundColor Yellow
kubectl apply -f k8s-local/00-namespace.yaml

# 3. Deploy MongoDB
Write-Host "`n[3/6] Deploying in-cluster MongoDB & seeding data..." -ForegroundColor Yellow
kubectl apply -f k8s-local/01-mongodb.yaml
Write-Host "Waiting for MongoDB pod to be ready..." -ForegroundColor Gray
kubectl wait --namespace purely --for=condition=ready pod -l app=mongodb --timeout=90s

# 4. Deploy Service Registry
Write-Host "`n[4/6] Deploying Eureka Service Registry..." -ForegroundColor Yellow
kubectl apply -f k8s-local/02-service-registry.yaml
Write-Host "Waiting for Service Registry pod to be ready..." -ForegroundColor Gray
kubectl wait --namespace purely --for=condition=ready pod -l app=registry --timeout=120s

# 5. Deploy ConfigMaps, Secrets, Microservices, Gateway & Frontend
Write-Host "`n[5/6] Deploying ConfigMaps, Secrets, Microservices, API Gateway, and Frontend..." -ForegroundColor Yellow
kubectl apply -f k8s-local/03-config-and-secrets.yaml
kubectl apply -f k8s-local/04-backend-services.yaml
kubectl apply -f k8s-local/05-api-gateway.yaml
kubectl apply -f k8s-local/06-frontend.yaml
kubectl apply -f k8s-local/07-ingress.yaml

# 6. Wait for all pods
Write-Host "`n[6/6] Waiting for all microservices to start..." -ForegroundColor Yellow
Start-Sleep -Seconds 5
kubectl get pods -n purely

Write-Host "`n==========================================" -ForegroundColor Green
Write-Host " Deployment applied successfully!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green

Write-Host "`nTo check status anytime:" -ForegroundColor Cyan
Write-Host "  kubectl get pods -n purely" -ForegroundColor White

Write-Host "`nTo access the application:" -ForegroundColor Cyan
Write-Host "  1. Direct NodePort URL (Docker Desktop / Kind / Minikube):" -ForegroundColor White
Write-Host "     http://localhost:30080" -ForegroundColor Green
Write-Host "  2. Or run the Port-Forward helper script:" -ForegroundColor White
Write-Host "     .\scripts\port-forward.ps1" -ForegroundColor Green
Write-Host "     - Frontend:         http://localhost:3000" -ForegroundColor Gray
Write-Host "     - Eureka Dashboard: http://localhost:8761" -ForegroundColor Gray
Write-Host "     - API Gateway:      http://localhost:8080" -ForegroundColor Gray
