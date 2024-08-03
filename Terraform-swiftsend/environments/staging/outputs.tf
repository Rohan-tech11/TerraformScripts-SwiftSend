output "vpc_id" {
  description = "ID of the VPC"
  value       = module.networking.vpc_id
}

output "ansible_server_private_ip" {
  description = "Private IP of Ansible Server"
  value       = module.ansible.ansible_server_private_ip
}

output "nat_public_ip" {
  description = "Public IP of the NAT Gateway"
  value       = module.networking.nat_public_ip
}