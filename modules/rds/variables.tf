variable "environment" {
  type        = string
  description = "The environment (dev/staging/prod)"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
}

# variable "private_subnet_ids" {
#   type        = list(string)
#   description = "List of private subnet IDs"
# }

//note : roll  back to private subnet once app is deployed into cluster
variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs"
}

variable "engine_version" {
  type        = string
  description = "The MySQL engine version"
  default     = "5.7"
}

variable "instance_class" {
  type        = string
  description = "The instance type of the RDS instance"
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  type        = number
  description = "The allocated storage in gigabytes"
  default     = 20
}

variable "storage_type" {
  type        = string
  description = "The storage type for the RDS instance"
  default     = "gp2"
}

variable "db_name" {
  type        = string
  description = "The name of the database to create when the DB instance is created"
}

variable "username" {
  type        = string
  description = "Username for the master DB user"
}

variable "password" {
  type        = string
  description = "Password for the master DB user"
}