variable "environment" {
  description = "Environment name"
}

variable "vpc_id" {
  description = "ID of the VPC"
}

variable "private_subnet_id" {
  description = "ID of the private subnet"
}

variable "ansible_sg_id" {
  description = "ID of the Ansible server security group"
}

variable "iam_instance_profile_name" {
  description = "Name of the IAM instance profile"
}

variable "key_name" {
  description = "Name of the EC2 key pair"
}

variable "instance_type" {
  description = "EC2 instance type"
}