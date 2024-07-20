variable "aws_region" {
  description = "AWS region"
  default     = "ca-central-1"
}
variable "environment" {
  description = "Environment name (e.g., staging, production)"
  type        = string
  default     = "staging"
}
