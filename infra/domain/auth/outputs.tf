output "auth_rds_endpoint" {
  description = "Endpoint de la base de datos de Auth"
  value       = module.auth_rds.db_endpoint
}

output "auth_service_secret_arn" {
  description = "ARN del secret de Auth"
  value       = module.auth_service_secret.secret_arn
}
