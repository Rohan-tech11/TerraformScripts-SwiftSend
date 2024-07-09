provider "aws" {
  region = var.aws_region
}

module "networking" {
  source = "../../modules/networking"

  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones  = var.availability_zones
}

module "security" {
  source = "../../modules/security"

  environment    = var.environment
  vpc_id         = module.networking.vpc_id
  vpc_cidr_block = var.vpc_cidr
}

module "ansible" {
  source = "../../modules/ansible"

  environment               = var.environment
  vpc_id                    = module.networking.vpc_id
  private_subnet_id         = module.networking.private_subnet_ids[0]
  ansible_sg_id             = module.security.ansible_sg_id
  iam_instance_profile_name = module.security.ansible_instance_profile_name
  key_name                  = var.key_name
  instance_type             = var.ansible_instance_type
}