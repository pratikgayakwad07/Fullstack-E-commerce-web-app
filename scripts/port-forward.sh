#!/usr/bin/env bash

echo "=========================================="
echo " Starting Port-Forwarding for Purely App"
echo "=========================================="
echo ""
echo "Forwarding services from namespace 'purely':"
echo " - Frontend Web App:  http://localhost:3000"
echo " - Eureka Dashboard:  http://localhost:8761"
echo " - API Gateway:       http://localhost:8080"
echo ""
echo "Press Ctrl+C at any time to stop port-forwarding."
echo ""

trap 'kill $(jobs -p) 2>/dev/null; echo ""; echo "Port forwarding stopped."; exit 0' SIGINT SIGTERM EXIT

kubectl port-forward -n purely svc/web-app-svc 3000:80 &
kubectl port-forward -n purely svc/registry-svc 8761:8761 &
kubectl port-forward -n purely svc/gateway-svc 8080:8080 &

wait
