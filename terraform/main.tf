variable "vpc_id" {
  description = "The ID of the VPC where EKS will be deployed"
  default     = "vpc-05425b426c515ed87"
}

variable "subnet_ids" {
  description = "List of subnet IDs where EKS will be deployed"
  type        = list(string)
  default     = [
    "subnet-0bbd3ddbf62846dc6",  # us-east-1d
    "subnet-08ff2cafb24127f97"   # us-east-1e
  ]
}
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.31"

  subnet_ids = data.aws_subnets.default.ids
  vpc_id     = data.aws_vpc.default.id

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access_cidrs = [
    "0.0.0.0/0"
  ]

  eks_managed_node_groups = {
    default = {
      desired_size = 2
      max_size     = 3
      min_size     = 1

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name

  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name

  depends_on = [module.eks]
}

resource "aws_ssm_parameter" "docker_cred" {
  name  = "/docker/registry/cred"
  type  = "SecureString"
  value = jsonencode({
    username = var.docker_username,
    password = var.docker_password,
    server   = "https://index.docker.io/v1/"
  })
}