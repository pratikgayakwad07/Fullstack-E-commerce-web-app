# 🚀 Local Kubernetes Deployment Guide

This guide walks you through deploying the **Purely Microservices E-Commerce Web Application** on your local laptop using **Docker Desktop Kubernetes**, **Minikube**, or **Kind**.

---

## 🏗️ Architecture in Local Kubernetes

```
┌───────────────────────────────────────────────────────────────────────────┐
│                      Kubernetes Namespace: purely                         │
│                                                                           │
│  [User Browser]                                                           │
│         │                                                                 │
│         ▼                                                                 │
│  ┌──────────────┐       /api/...       ┌─────────────┐                    │
│  │ web-app-svc  │ ───────────────────> │ gateway-svc │                    │
│  │ (React/Nginx)│                      │(Spring Cloud│                    │
│  │  Port 80/    │                      │  Gateway)   │                    │
│  │ NodePort30080│                      │  Port 8080  │                    │
│  └──────────────┘                      └──────┬──────┘                    │
│                                               │                           │
│                     ┌─────────────────────────┼────────────────────────┐  │
│                     │                         │                        │  │
│                     ▼                         ▼                        ▼  │
│             ┌───────────────┐         ┌───────────────┐        ┌─────────┐│
│             │  auth-svc     │         │ category-svc  │  ...   │other-svc││
│             │  Port 9030    │         │  Port 9000    │        │         ││
│             └───────┬───────┘         └───────┬───────┘        └────┬────┘│
│                     │                         │                     │     │
│                     ▼                         ▼                     ▼     │
│             ┌─────────────────────────────────────────────────────────┐   │
│             │            mongodb-svc (In-Cluster MongoDB)             │   │
│             │        Port 27017 (Pre-seeded with Sample Data)         │   │
│             └─────────────────────────────────────────────────────────┘   │
│                                                                           │
│             ┌─────────────────────────────────────────────────────────┐   │
│             │            registry-svc (Eureka Server)                 │   │
│             │                      Port 8761                          │   │
│             └─────────────────────────────────────────────────────────┘   │
└───────────────────────────────────────────────────────────────────────────┘
```

---

## 📋 Prerequisites

Ensure you have the following installed:
- **Docker** (Docker Desktop is already installed)
- **kubectl**
- (Optional) **Minikube** or **Kind**

---

## ⚙️ Step 1: Start Your Local Kubernetes Cluster

Choose **ONE** of the following options:

### Option A: Docker Desktop Kubernetes (Recommended on Windows)
1. Open **Docker Desktop**.
2. Click the ⚙️ **Settings** icon (top right).
3. Select the **Kubernetes** tab on the left.
4. Check **Enable Kubernetes** and click **Apply & restart**.
5. Verify in PowerShell:
   ```powershell
   kubectl cluster-info
   ```

### Option B: Minikube
```powershell
minikube start --cpus=4 --memory=8192
```

### Option C: Kind
```powershell
kind create cluster --name purely
```

---

## 📦 Step 2: Build Docker Images Locally

Run the automated build script to build all 10 container images:

#### On Windows (PowerShell):
```powershell
.\scripts\build-images.ps1
```

#### On Linux / WSL / macOS (Bash):
```bash
chmod +x ./scripts/*.sh
./scripts/build-images.sh
```

> **Note for Minikube / Kind users:**
> - If using Minikube: images built on host can be loaded via `minikube image load purely/service-registry:latest ...` or build directly inside minikube via `eval $(minikube docker-env)`.
> - If using Docker Desktop: images built with `docker build` are immediately available to the local Kubernetes cluster!

---

## 🚀 Step 3: Deploy to Local Kubernetes

Deploy all resources (Namespace, MongoDB + seed data, Service Registry, Config/Secrets, 7 Microservices, API Gateway, and Frontend):

#### On Windows (PowerShell):
```powershell
.\scripts\deploy-local.ps1
```

#### On Linux / WSL / macOS (Bash):
```bash
./scripts/deploy-local.sh
```

Alternatively, you can apply using `kubectl`:
```powershell
kubectl apply -f k8s-local/
# or
kubectl apply -k k8s-local/
```

---

## 🌐 Step 4: Access the Application

### Method 1: NodePort (Direct Access)
Open your browser and navigate to:
👉 **[http://localhost:30080](http://localhost:30080)**

*(If using Minikube, run `minikube service web-app-svc -n purely` to open the URL)*.

---

### Method 2: Port-Forwarding Helper (Standard Localhost Ports)
Run the port-forward script:
```powershell
.\scripts\port-forward.ps1
```
Now access:
- **Frontend Web Application**: [http://localhost:3000](http://localhost:3000)
- **Eureka Service Registry Dashboard**: [http://localhost:8761](http://localhost:8761)
- **API Gateway**: [http://localhost:8080](http://localhost:8080)

---

## 🔍 Step 5: Verify Deployment & Status

### Check Pod Status:
```powershell
kubectl get pods -n purely
```

You should see all pods running:
```
NAME                                READY   STATUS    RESTARTS   AGE
mongodb-depl-xxxxxxxxx-xxxxx        1/1     Running   0          2m
registry-depl-xxxxxxxxx-xxxxx       1/1     Running   0          2m
auth-depl-xxxxxxxxx-xxxxx           1/1     Running   0          1m
category-depl-xxxxxxxxx-xxxxx       1/1     Running   0          1m
product-depl-xxxxxxxxx-xxxxx        1/1     Running   0          1m
cart-depl-xxxxxxxxx-xxxxx           1/1     Running   0          1m
order-depl-xxxxxxxxx-xxxxx          1/1     Running   0          1m
user-depl-xxxxxxxxx-xxxxx           1/1     Running   0          1m
notification-depl-xxxxxxxxx-xxxxx   1/1     Running   0          1m
gateway-depl-xxxxxxxxx-xxxxx        1/1     Running   0          1m
web-app-depl-xxxxxxxxx-xxxxx        1/1     Running   0          1m
```

### Check Eureka Registration:
Open `http://localhost:8761` to verify all microservices (`AUTH-SERVICE`, `CATEGORY-SERVICE`, `PRODUCT-SERVICE`, `CART-SERVICE`, `ORDER-SERVICE`, `USER-SERVICE`, `NOTIFICATION-SERVICE`, `API-GATEWAY`) are registered and UP.

### View Service Logs:
```powershell
# API Gateway logs
kubectl logs -n purely -l app=gateway -f

# Product service logs
kubectl logs -n purely -l app=product -f

# Frontend logs
kubectl logs -n purely -l app=web-app -f
```

---

## 🛠️ Configuration Options

### Using MongoDB Atlas instead of In-Cluster MongoDB
If you wish to use your remote MongoDB Atlas cluster instead of the local MongoDB pod:
1. Open [`k8s-local/03-config-and-secrets.yaml`](file:///c:/Users/riyag/Fullstack-E-commerce-web-app/k8s-local/03-config-and-secrets.yaml).
2. Update the `SPRING_DATA_MONGODB_URI_*` values in `purely-secrets` with your Atlas connection strings (e.g. `mongodb+srv://<user>:<password>@cluster0.mongodb.net/purely_auth_service`).
3. Re-apply the configuration:
   ```powershell
   kubectl apply -f k8s-local/03-config-and-secrets.yaml
   kubectl rollout restart deployment -n purely
   ```

### Enabling Real Email Sending
1. Open [`k8s-local/03-config-and-secrets.yaml`](file:///c:/Users/riyag/Fullstack-E-commerce-web-app/k8s-local/03-config-and-secrets.yaml).
2. In `notification-secret`, set `SPRING_MAIL_USERNAME` and `SPRING_MAIL_PASSWORD` to your Gmail / SMTP credentials.
3. Apply changes and restart the notification deployment.

---

## 🧹 Teardown / Cleanup

To delete all deployed resources and free up laptop resources:

#### On Windows:
```powershell
.\scripts\teardown-local.ps1
```

#### On Linux / WSL / macOS:
```bash
./scripts/teardown-local.sh
```
