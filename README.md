# Terraform Infrastructure for SwiftSend Application

This repository contains Terraform scripts to provision the infrastructure for the SwiftSend application on AWS. SwiftSend is a Java-based middleware platform developed using the Spring Boot framework, with MySQL as its database, React for the front end, and email authentication features.

## Directory Structure

```text
.
├── environments
│   ├── staging
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── terraform.tfvars
├── modules
│   ├── network
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── compute
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── storage
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── README.md
