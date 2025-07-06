data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.31"

  subnet_ids = data.aws_subnets.default.ids
  vpc_id     = data.aws_vpc.default.id

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
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
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