

  <br><br>
  <a href="http://test.dreamtoday.xyz">
    <img src="https://upload.wikimedia.org/wikipedia/commons/0/08/Netflix_2015_logo.svg" alt="Netflix Logo" width="100" height="32">
  </a>
</div>

<br />

# 🚀 Netflix Clone Deployment Project – DevOps Focused

This is a **Netflix Clone App** deployed to **AWS EKS** using **Docker**, **ArgoCD**, and **Kubernetes**, with **Trivy** for container image scanning, **Prometheus** for monitoring, and a fully configured **Ingress with CNAME & Load Balancer**.

---

## 🌐 Live Demo:
🔗 [http://test.dreamtoday.xyz](http://test.dreamtoday.xyz)
# 🚀 Deploy Netflix App with DevOps Stack (EC2 + Docker + Kubernetes + ArgoCD + Prometheus + Trivy + Secrets)

This project demonstrates how to build and deploy a Netflix clone using:

- **EC2** (AWS)
- **Docker**
- **Kubernetes** (EKS)
- **ArgoCD** for CD
- **Prometheus** for Monitoring
- **Trivy** for Security Scanning
- **Ingress with CNAME & Load Balancer**
- **Environment Secrets Management**

---

## 📦 Prerequisites

- AWS CLI configured
- EC2 Instance (Ubuntu 22.04)
- IAM Role for EKS & Load Balancer
- `kubectl`, `helm`, `docker` installed

---

## 🖥️ EC2 Setup & Docker

```bash
sudo apt update && sudo apt install -y docker.io
sudo usermod -aG docker $USER
newgrp docker
git clone https://github.com/pankajsinghveersatech/DevSecOps-Project-first.git
cd DevSecOps-Project-first
docker build -t netflix-app .
docker run -d -p 8081:80 netflix-app
```

---

## 🔐 Secrets Management

```bash
kubectl create secret generic netflix-secrets --from-literal=TMDB_API_KEY=your_api_key
```

In deployment.yaml, reference it using:

```yaml
env:
- name: TMDB_API_KEY
  valueFrom:
    secretKeyRef:
      name: netflix-secrets
      key: TMDB_API_KEY
```

---

## 🧪 Trivy Scan

```bash
trivy image netflix-app
```

---

## 📦 Kubernetes & Ingress Setup

```bash
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/ingress.yaml
```

---

## 🌐 Domain Mapping

Configure your DNS provider to add a **CNAME** record:

```text
Type: CNAME
Name: app.example.com
Value: <your-alb-hostname>.elb.amazonaws.com
```

---

## 🔄 Continuous Delivery with ArgoCD

```bash
# Connect to ArgoCD UI and apply:
kubectl apply -f argocd/netflix-app.yaml
```

---

## 📊 Prometheus Monitoring

Install Node Exporter:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
kubectl create ns monitoring
helm install node-exporter prometheus-community/prometheus-node-exporter -n monitoring
```

Prometheus config scrape endpoint:

```yaml
- job_name: 'netflix-app'
  static_configs:
    - targets: ['<node-ip>:9100']
```

---

## ✅ Project Outcome

- Learned real-world DevOps practices
- Built full CI/CD pipeline
- Managed secrets securely
- Monitored with Prometheus
- Automated with ArgoCD
- Secure builds with Trivy
