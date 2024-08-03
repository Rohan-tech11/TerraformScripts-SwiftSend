output "ansible_sg_id" {
  description = "ID of the Ansible server security group"
  value       = aws_security_group.ansible.id
}

output "ansible_instance_profile_name" {
  description = "Name of the IAM instance profile for Ansible"
  value       = aws_iam_instance_profile.ansible_profile.name
}

# Output the role ARN for use in EKS config
output "ansible_role_arn" {
  value = aws_iam_role.ansible_role.arn
}