output "ansible_server_private_ip" {
  description = "Private IP of Ansible Server"
  value       = aws_instance.ansible_server.private_ip
}