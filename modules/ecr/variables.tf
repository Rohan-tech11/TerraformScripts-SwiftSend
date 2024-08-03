variable "environment" {
  type        = string
  description = "The environment (dev, prod, etc.)"
}

variable "repository_name" {
  type        = string
  description = "Name of the ECR repository"
}

variable "eks_node_role_name" {
  type        = string
  description = "Name of the IAM role used by EKS nodes"
}