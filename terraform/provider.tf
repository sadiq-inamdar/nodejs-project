terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

  backend "s3" {
    bucket         = "nodejs-statefile"
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "nodejs-statefile"
    encrypt        = true
  }
}