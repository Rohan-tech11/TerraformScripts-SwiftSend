aws_region           = "ca-central-1"
environment          = "staging"
vpc_cidr             = "10.1.0.0/16"
public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidrs = ["10.1.10.0/24", "10.1.20.0/24"]
availability_zones   = ["ca-central-1a", "ca-central-1b"]
key_name             = "staging-key-pair"
ansible_instance_type = "t3.small"