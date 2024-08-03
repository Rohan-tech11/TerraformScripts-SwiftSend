variable "environment" {}
variable "aws_region" {
  
}
variable "vpc_id" {}
variable "private_subnet_ids" {}
variable "cluster_name" {}
variable "node_group_name" {}
variable "instance_types" {}
variable "desired_size" {}
variable "min_size" {}
variable "max_size" {}
variable "authentication_mode" {}
variable "ansible_role_arn" {}
variable "ecr_access_policy_arn" {
  description = "ARN of the ECR access policy"
  type        = string
}



