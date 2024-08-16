# S3 Backend Configuration
# ------------------------
# Author: Rohan
#
# This is a template for the S3 backend configuration.
# Replace the placeholder values (YOUR_*) with your own before use.
# 
# To use this configuration:
# 1. Replace placeholders with your actual values
# 2. Either include this block in your Terraform configuration files
#    or use it as a separate backend config file when initializing Terraform
# 
# Note: Ensure you have the necessary permissions to access the specified 
# S3 bucket and DynamoDB table in your AWS account.

terraform {
  backend "s3" {
    bucket         = "YOUR_S3_BUCKET_NAME"
    key            = "PATH/TO/YOUR/TERRAFORM.tfstate"
    region         = "YOUR_AWS_REGION"
    dynamodb_table = "YOUR_DYNAMODB_TABLE_NAME"
    encrypt        = true
  }
}