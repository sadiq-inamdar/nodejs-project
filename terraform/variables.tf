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