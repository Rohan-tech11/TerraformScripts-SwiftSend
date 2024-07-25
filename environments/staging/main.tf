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


module "eks" {
  source = "../../modules/eks"
  environment      = var.environment
  vpc_id           = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids
  cluster_name     = "${var.environment}-jenkins-cluster"
  node_group_name  = "${var.environment}-jenkins-nodes"
  instance_types   = var.eks_instance_types
  desired_size     = var.eks_desired_size
  min_size         = var.eks_min_size
  max_size         = var.eks_max_size
  authentication_mode = var.eks_authentication_mode
  ansible_role_arn = module.security.ansible_role_arn

}

module "efs" {
  source = "../../modules/efs"
  environment    = var.environment
  vpc_id         = module.networking.vpc_id
  subnet_ids     = module.networking.private_subnet_ids
  eks_sg_id      = module.eks.node_security_group_id
}


module "dynamoDB" {
  source = "../../modules/dynamodb"
  environment    = var.environment
  aws_region     = var.aws_region
}


module "s3-backend" {
  source = "../../modules/s3-backend"
  environment    = var.environment
  aws_region     = var.aws_region
}

module "rds" {
  source = "../../modules/rds"

  environment        = var.environment
  vpc_id             = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  //private_subnet_ids = module.networking.private_subnet_ids  
  db_name            = var.rds_db_name
  username           = var.rds_username
  password           = var.rds_password
}

module "s3-ansible-ssm" {
  source = "../../modules/s3-ansible-ssm"
  bucket_name = "ansible-ssm-bucket-${var.environment}"
  environment = var.environment
}


