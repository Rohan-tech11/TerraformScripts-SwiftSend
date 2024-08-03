variable "bucket_name" {
  description = "Name of the S3 bucket for Ansible SSM"
  type        = string
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
}