module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.31"

  subnet_ids = var.subnet_ids
  vpc_id     = var.vpc_id  

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

   manage_aws_auth_configmap = true

   aws_auth_roles = [
        {
        rolearn  = "arn:aws:iam::643683863113:role/github-terraform-role" # OIDC GitHub Actions role
        username = "github"
        groups   = ["system:masters"]
        }
  ]
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