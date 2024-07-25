output "rds_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = aws_db_instance.default.endpoint
}

output "rds_port" {
  description = "The port the RDS instance is listening on"
  value       = aws_db_instance.default.port
}

output "rds_username" {
  description = "The master username for the RDS instance"
  value       = aws_db_instance.default.username
}

output "rds_db_name" {
  description = "The name of the database"
  value       = aws_db_instance.default.db_name
}