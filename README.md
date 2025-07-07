# Node.js EKS Deployment Project

This project demonstrates a complete CI/CD pipeline for deploying a Node.js application to Amazon EKS using GitHub Actions, Terraform, and Kubernetes.

## Can access from browser
# http://a39a7ba3ff0144c39b9d6664abcc1fb1-1158970736.us-east-1.elb.amazonaws.com/

## 🏗️ Architecture Overview

The project implements a modern DevOps pipeline with the following components:

- **Frontend**: Node.js application with Docker containerization
- **Infrastructure**: AWS EKS cluster provisioned via Terraform
- **CI/CD**: GitHub Actions workflows for automated build and deployment
- **Kubernetes**: Deployment manifests with LoadBalancer service

## 📁 Project Structure

```
.
├── .github/workflows/          # GitHub Actions workflows
│   ├── confirmation.yaml       # Manual confirmation workflow
│   ├── deploy.yml              # EKS deployment workflow
│   ├── docker-image.yml        # Docker build and push workflow
│   └── terraform.yml           # Infrastructure deployment workflow
├── frontend/                   # Node.js application source code
│   ├── public/                 # Static assets
│   ├── Dockerfile              # Container build instructions
│   ├── README.md               # Frontend documentation
│   ├── app.js                  # Main application file
│   └── package.json            # Node.js dependencies
├── k8s/                        # Kubernetes manifests
│   ├── deployment.yaml         # Pod deployment configuration
│   └── service.yaml            # LoadBalancer service configuration
└── terraform/                  # Infrastructure as Code
    ├── main.tf                 # EKS cluster and resources
    ├── provider.tf             # AWS provider configuration
    └── variables.tf            # Terraform variables
```

## 🚀 Deployment Pipeline

### 1. Docker Image Build (`docker-image.yml`)
- Builds Docker image from `frontend/Dockerfile`
- Pushes image to Docker Hub registry
- Triggered on code changes to frontend

### 2. Infrastructure Deployment (`terraform.yml`)
- Provisions AWS EKS cluster using Terraform
- Creates SSM parameters for Docker registry credentials
- Sets up IAM roles and permissions
- Configures VPC, subnets, and security groups

### 3. Application Deployment (`deploy.yml`)
- Deploys application to EKS cluster
- Pulls Docker credentials from SSM Parameter Store
- Applies Kubernetes manifests (`deployment.yaml`, `service.yaml`)
- Configures LoadBalancer for external access

## 🔧 Key Components

### AWS Resources Created
- **EKS Cluster**: Managed Kubernetes cluster with worker nodes
- **SSM Parameters**: Secure storage for Docker registry credentials
- **IAM Roles**: GitHub Actions role with EKS admin permissions
- **Load Balancer**: External access to the application

### GitHub Actions Workflows
- **Automated CI/CD**: Build, test, and deploy pipeline
- **Security**: Uses OIDC for AWS authentication
- **Flexibility**: Manual workflow dispatch available

### Kubernetes Configuration
- **Deployment**: Manages pod replicas and rolling updates
- **Service**: LoadBalancer type for external traffic
- **Secrets**: Docker registry authentication

## 🛠️ Prerequisites

- AWS Account with appropriate permissions
- GitHub repository with Actions enabled
- Docker Hub account for image registry
- Terraform >= 1.0
- kubectl configured for EKS access

## 📋 Setup Instructions

### 1. Configure AWS OIDC Provider
```bash
# Create OIDC provider for GitHub Actions
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1
```

### 2. Set GitHub Secrets
Configure the following secrets in your GitHub repository:
- `DOCKER_USERNAME`: Docker Hub username
- `DOCKER_PASSWORD`: Docker Hub password
- `AWS_REGION`: AWS region (e.g., us-east-1)

### 3. Update Configuration
- Modify `terraform/variables.tf` with your specific values
- Update Docker image references in `k8s/deployment.yaml`
- Adjust IAM role ARNs in workflow files

### 4. Deploy Infrastructure
```bash
# Navigate to terraform directory
cd terraform

# Initialize and apply
terraform init
terraform plan
terraform apply
```

### 5. Deploy Application
Trigger the deployment workflow manually or push changes to trigger automatic deployment.

## 🔐 Security Features

- **OIDC Authentication**: No long-lived AWS credentials
- **Least Privilege**: IAM roles with minimal required permissions
- **Secrets Management**: Docker credentials stored in SSM Parameter Store

## 🌐 Access Your Application

After successful deployment, find your application URL:
```bash
kubectl get services
# Look for the LoadBalancer EXTERNAL-IP
```

## 🔍 Troubleshooting

### Common Issues
1. **EKS Authentication**: Ensure GitHub Actions role has proper EKS access
2. **Docker Pull**: Verify Docker credentials in SSM Parameter Store
3. **Resource Limits**: Monitor node capacity and pod resource requests

### Useful Commands
```bash
# Check EKS cluster status
aws eks describe-cluster --name nodejs-frontend-cluster

# View pod logs
kubectl logs -f deployment/nodejs-app

# Check service status
kubectl get svc nodejs-service
```


---

**Note**: This project is designed for educational and demonstration purposes. For production use, additional security hardening and monitoring should be implemented.
