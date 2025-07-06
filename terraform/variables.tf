variable "aws_region" {
  default = "us-east-1"
}

variable "cluster_name" {
  default = "nodejs-frontend-cluster"
}

variable "docker_username" {
  type = string
}

variable "docker_password" {
  type = string
}

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
    "subnet-0b1a2ea44d1840b3b",
    "subnet-0cd54096a238f1782",
    "subnet-02da3f9961e298f72"
  ]
}