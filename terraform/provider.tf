provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

terraform {
  backend "s3" {
    bucket         = "nodejs-statefile"
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "nodejs-statefile"
    encrypt        = true
  }
}
