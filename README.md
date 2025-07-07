# NodeJS Project – Scalable Cloud App on EKS

## Overview

This project demonstrates a full CI/CD pipeline for a Node.js application deployed on AWS EKS using Docker, Terraform, and Kubernetes, fully automated with GitHub Actions.

## Directory Structure

```
.
├── frontend/              # Node.js app and Dockerfile
│   ├── src/
│   ├── Dockerfile
│   └── ...
├── terraform/             # Infrastructure as Code
│   ├── main.tf
│   └── ...
├── k8s/                   # Kubernetes manifests
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ...
├── .github/workflows/
│   ├── docker-build-image.yaml
│   ├── terraform.yaml
│   └── deploy.yaml
└── README.md
```

## Architecture

- **Node.js Frontend**: Containerized using Docker.
- **CI/CD**: Automated builds and deployments using GitHub Actions.
- **Container Registry**: DockerHub used for storing built images.
- **Infrastructure**: AWS EKS and SSM parameters provisioned using Terraform.
- **Deployment**: Kubernetes deployments and LoadBalancer services for public access.

### Deployment Flow

1. **Build & Push Docker Image**
   - `frontend/Dockerfile` defines the app container.
   - `.github/workflows/docker-build-image.yaml` builds and pushes the image to Docker Hub.

2. **Provision Infrastructure**
   - `terraform/main.tf` defines AWS EKS, IAM, VPC, SSM, etc.
   - `.github/workflows/terraform.yaml` runs Terraform to create/update infra.

3. **Deploy to EKS with Kubernetes**
   - `k8s/deployment.yaml` and `k8s/service.yaml` define K8s resources.
   - `.github/workflows/deploy.yaml` applies these to the EKS cluster.

## How to Run

### Prerequisites

- AWS account with permissions for EKS, SSM, IAM.
- DockerHub account for image registry.
- GitHub repository with Actions enabled.
- Terraform installed locally (for manual runs).

### 1. Build & Push Docker Image

Automatically triggered by push to `main` (see `.github/workflows/docker-build-image.yaml`):

```bash
cd frontend
docker build -t <your-dockerhub-username>/nodejs-app:latest .
docker push <your-dockerhub-username>/nodejs-app:latest
```

### 2. Provision AWS Infrastructure

Automatically triggered by workflow (`.github/workflows/terraform.yaml`), or run locally:

```bash
cd terraform
terraform init
terraform apply
```

See `terraform/main.tf` for exact resources created.

### 3. Deploy to Kubernetes

Automatically triggered (see `.github/workflows/deploy.yaml`), or run manually:

```bash
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```

This deploys the app and exposes it with a LoadBalancer service.

## Workflows

- **docker-build-image.yaml**: Builds and pushes Docker image.
- **terraform.yaml**: Applies Terraform code for infra provisioning.
- **deploy.yaml**: Deploys Kubernetes manifests to EKS.

## Reference Files

- **frontend/Dockerfile**: Container build instructions.
- **terraform/main.tf**: Main Terraform infrastructure code.
- **k8s/deployment.yaml & service.yaml**: K8s deployment and service definitions.

## Contributing

Contributions welcome! Please fork and send PRs.

## License

[MIT](LICENSE)
