variable "aws_region" {
  description = "AWS region"
  default     = "ca-central-1"
}

variable "environment" {
  description = "Environment name"
  default     = "staging"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  default     = "10.1.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.1.10.0/24", "10.1.20.0/24"]
}

variable "availability_zones" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["ca-central-1a", "ca-central-1b"]
}

//ansible variables
variable "key_name" {
  description = "EC2 Key Pair name"
}

variable "ansible_instance_type" {
  description = "EC2 instance type for Ansible server"
  default     = "t3.small"
}

//eks variables
variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "eks_authentication_mode" {
  description = "Authentication mode of the EKS cluster"
  type        = string
}
variable "eks_node_group_name" {
  description = "Name of the EKS node group"
  type        = string
}

variable "eks_instance_types" {
  description = "List of instance types for EKS nodes"
  type        = list(string)
}

variable "eks_desired_size" {
  description = "Desired size of EKS node group"
  type        = number
}

variable "eks_min_size" {
  description = "Minimum size of EKS node group"
  type        = number
}

variable "eks_max_size" {
  description = "Maximum size of EKS node group"
  type        = number
}



# EFS Variables
variable "efs_creation_token" {
  description = "Creation token for the EFS file system"
  type        = string
}

variable "efs_encrypted" {
  description = "Whether the EFS file system should be encrypted"
  type        = bool
}