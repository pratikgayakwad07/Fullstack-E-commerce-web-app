# ==============================================================================
# Port Forwarding Helper for Purely Local Kubernetes Deployment
# ==============================================================================
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " Starting Port-Forwarding for Purely App" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

Write-Host "`nForwarding services from namespace 'purely':" -ForegroundColor Yellow
Write-Host " - Frontend Web App:  http://localhost:3000" -ForegroundColor Green
Write-Host " - Eureka Dashboard:  http://localhost:8761" -ForegroundColor Green
Write-Host " - API Gateway:       http://localhost:8080" -ForegroundColor Green
Write-Host "`nPress Ctrl+C at any time to stop port-forwarding.`n" -ForegroundColor Gray

# Start background jobs for port forwarding
$job1 = Start-Job -ScriptBlock { kubectl port-forward -n purely svc/web-app-svc 3000:80 }
$job2 = Start-Job -ScriptBlock { kubectl port-forward -n purely svc/registry-svc 8761:8761 }
$job3 = Start-Job -ScriptBlock { kubectl port-forward -n purely svc/gateway-svc 8080:8080 }

try {
    while ($true) {
        Start-Sleep -Seconds 1
    }
} finally {
    Write-Host "`nStopping port forwarding..." -ForegroundColor Yellow
    Stop-Job $job1, $job2, $job3 -ErrorAction SilentlyContinue
    Remove-Job $job1, $job2, $job3 -ErrorAction SilentlyContinue
    Write-Host "Port forwarding stopped." -ForegroundColor Green
}
