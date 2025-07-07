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
}

# Add access entry for GitHub Actions role
resource "aws_eks_access_entry" "github_actions" {
  cluster_name      = module.eks.cluster_name
  principal_arn     = "arn:aws:iam::643683863113:role/github-terraform-role"
  type              = "STANDARD"
  kubernetes_groups = []
}

resource "aws_eks_access_policy_association" "github_actions" {
  cluster_name  = module.eks.cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = "arn:aws:iam::643683863113:role/github-terraform-role"
  
  access_scope {
    type = "cluster"
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
