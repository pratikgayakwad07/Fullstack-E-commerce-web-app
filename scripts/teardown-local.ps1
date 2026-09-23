# ==============================================================================
# Teardown Purely Local Kubernetes Deployment
# ==============================================================================
$RootDir = Split-Path -Parent $PSScriptRoot
Set-Location $RootDir

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " Teardown Purely Local Kubernetes Resources" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

Write-Host "`nDeleting namespace 'purely' and all associated resources..." -ForegroundColor Yellow
kubectl delete namespace purely --ignore-not-found=true

Write-Host "`n==========================================" -ForegroundColor Green
Write-Host " Cleanup complete!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
