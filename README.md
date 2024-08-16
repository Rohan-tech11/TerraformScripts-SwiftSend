# Infrastructure as Code for SwiftSend Cloud-Native Application Deployment

Author: Rohan

## Capstone Project Overview

This repository contains Terraform scripts developed as part of a capstone project to provision and manage a robust, scalable cloud infrastructure for deploying the SwiftSend cloud-native application. The infrastructure is designed with security, scalability, and best practices in mind.

## Key Components

1. **S3 Backend Configuration**:

   - S3 bucket for storing Terraform state files
   - DynamoDB table for state locking

2. **Networking**:

   - Custom VPC
   - Public and private subnets
   - Internet Gateway
   - NAT Gateway for private subnet internet access
   - Route tables and associations

3. **EC2 Instance**:

   - Private EC2 instance for Ansible operations

4. **EKS (Elastic Kubernetes Service)**:

   - Kubernetes cluster for Jenkins and application workloads
   - Node groups with autoscaling capabilities

5. **RDS (Relational Database Service)**:

   - Managed database for application data

6. **EFS (Elastic File System)**:

   - Persistent storage for Jenkins stateful sets

7. **Security**:

   - IAM roles and policies following the principle of least privilege
   - Security groups for access control

8. **ECR (Elastic Container Registry)**:

   - Repository for storing Docker images

9. **Additional Services**:
   - DynamoDB tables for application use

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform v1.0.0 or later
- Basic understanding of AWS services and Terraform

## Usage

1. Clone this repository:
   git clone https://github.com/Rohan-tech11/TerraformScripts-SwiftSend.git
   cd TerraformScripts-SwiftSend

2. Initialize Terraform: terraform init

3. Review and modify variables in `terraform.tfvars` as needed.

4. Plan the infrastructure:terraform plan

5. Apply the configuration:terraform apply

6. To destroy the infrastructure:terraform destroy

## Important Notes

- This infrastructure may incur AWS charges. Be sure to review the AWS pricing for each service before applying.
- Some modules may require additional setup or dependencies. Refer to individual module documentation for specific requirements.
- Ensure you have the necessary AWS permissions to create and manage these resources.
- The EKS cluster may take 10-15 minutes to provision.
- Remember to destroy resources when they're no longer needed to avoid unnecessary costs.

## Architecture Diagram

## Contributing

Contributions to improve the scripts or documentation are welcome. Please follow the standard fork-and-pull request workflow.

## Acknowledgments

Special thanks to Professor Ozzie Shahmadar for guidance throughout this capstone project.

For any questions or support, please open an issue in this repository.
