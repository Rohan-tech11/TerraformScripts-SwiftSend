aws_region           = "ca-central-1"
environment          = "staging"
vpc_cidr             = "10.1.0.0/16"
public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidrs = ["10.1.10.0/24", "10.1.20.0/24"]
availability_zones   = ["ca-central-1a", "ca-central-1b"]
key_name             = "staging-key-pair"
ansible_instance_type = "t2.micro"
eks_cluster_name    = "staging-jenkins-cluster"
eks_node_group_name = "staging-jenkins-nodes"
eks_instance_types  = ["t2.micro"]
eks_desired_size    = 2
eks_min_size        = 1
eks_max_size        = 3
efs_creation_token  = "staging-jenkins-efs"
efs_encrypted       = true
