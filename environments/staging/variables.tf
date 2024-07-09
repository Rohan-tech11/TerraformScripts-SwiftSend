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

variable "key_name" {
  description = "EC2 Key Pair name"
}

variable "ansible_instance_type" {
  description = "EC2 instance type for Ansible server"
  default     = "t3.small"
}