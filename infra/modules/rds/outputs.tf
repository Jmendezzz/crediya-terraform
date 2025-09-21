output "db_endpoint" {
  value       = aws_db_instance.this.endpoint
  description = "Endpoint de la base de datos"
}

output "db_name" {
  value       = aws_db_instance.this.db_name
  description = "Nombre de la base de datos"
}

output "db_username" {
  value       = aws_db_instance.this.username
  description = "Usuario de la base de datos"
}
