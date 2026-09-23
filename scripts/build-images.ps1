# ==============================================================================
# Build Docker Images for Local Kubernetes Deployment
# ==============================================================================
$ErrorActionPreference = "Stop"

$RootDir = Split-Path -Parent $PSScriptRoot
Set-Location $RootDir

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " Building Docker Images for Local K8s" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

$images = @(
    @{ Name = "purely/service-registry:latest"; Path = "microservice-backend/service-registry" },
    @{ Name = "purely/api-gateway:latest";      Path = "microservice-backend/api-gateway" },
    @{ Name = "purely/auth-service:latest";     Path = "microservice-backend/auth-service" },
    @{ Name = "purely/category-service:latest"; Path = "microservice-backend/category-service" },
    @{ Name = "purely/product-service:latest";  Path = "microservice-backend/product-service" },
    @{ Name = "purely/cart-service:latest";     Path = "microservice-backend/cart-service" },
    @{ Name = "purely/order-service:latest";    Path = "microservice-backend/order-service" },
    @{ Name = "purely/user-service:latest";     Path = "microservice-backend/user-service" },
    @{ Name = "purely/notification-service:latest"; Path = "microservice-backend/notification-service" },
    @{ Name = "purely/web-app:latest";          Path = "frontend" }
)

$total = $images.Count
$count = 0

foreach ($img in $images) {
    $count++
    Write-Host "`n[$count/$total] Building image: $($img.Name)..." -ForegroundColor Yellow
    docker build -t $img.Name -f "$($img.Path)/Dockerfile" $img.Path
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error building $($img.Name)" -ForegroundColor Red
        exit 1
    }
}

Write-Host "`n==========================================" -ForegroundColor Green
Write-Host " All images built successfully!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green

# If using minikube or kind, offer loading hint
if (Get-Command minikube -ErrorAction SilentlyContinue) {
    Write-Host "Tip: If using Minikube, you can load images via:" -ForegroundColor Cyan
    Write-Host "  minikube image load purely/service-registry:latest purely/api-gateway:latest purely/auth-service:latest purely/category-service:latest purely/product-service:latest purely/cart-service:latest purely/order-service:latest purely/user-service:latest purely/notification-service:latest purely/web-app:latest" -ForegroundColor Gray
}
if (Get-Command kind -ErrorAction SilentlyContinue) {
    Write-Host "Tip: If using Kind, you can load images via:" -ForegroundColor Cyan
    Write-Host "  kind load docker-image purely/service-registry:latest purely/api-gateway:latest purely/auth-service:latest purely/category-service:latest purely/product-service:latest purely/cart-service:latest purely/order-service:latest purely/user-service:latest purely/notification-service:latest purely/web-app:latest" -ForegroundColor Gray
}
