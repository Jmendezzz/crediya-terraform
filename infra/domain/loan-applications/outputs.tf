# loan_application_approved
output "loan_application_approved_arn" {
  description = "ARN de la cola loan_application_approved"
  value       = module.loan_application_approved.queue_arn
}

output "loan_application_approved_url" {
  description = "URL de la cola loan_application_approved"
  value       = module.loan_application_approved.queue_url
}

# loan_application_auto_validation_completed
output "loan_application_auto_validation_completed_arn" {
  description = "ARN de la cola loan_application_auto_validation_completed"
  value       = module.loan_application_auto_validation_completed.queue_arn
}

output "loan_application_auto_validation_completed_url" {
  description = "URL de la cola loan_application_auto_validation_completed"
  value       = module.loan_application_auto_validation_completed.queue_url
}

# loan_application_auto_validation_requested
output "loan_application_auto_validation_requested_arn" {
  description = "ARN de la cola loan_application_auto_validation_requested"
  value       = module.loan_application_auto_validation_requested.queue_arn
}

output "loan_application_auto_validation_requested_url" {
  description = "URL de la cola loan_application_auto_validation_requested"
  value       = module.loan_application_auto_validation_requested.queue_url
}

# loan_application_state_changed
output "loan_application_state_changed_arn" {
  description = "ARN de la cola loan_application_state_changed"
  value       = module.loan_application_state_changed.queue_arn
}

output "loan_application_state_changed_url" {
  description = "URL de la cola loan_application_state_changed"
  value       = module.loan_application_state_changed.queue_url
}

# IAM
output "iam_loan_service_user" {
  value = module.iam_loan_service.user_name
}
output "iam_loan_service_access_key" {
  value = module.iam_loan_service.access_key_id
}
output "iam_loan_service_secret_key" {
  value     = module.iam_loan_service.secret_access_key
  sensitive = true
}

# Secret
output "loan_service_secret_arn" {
  value = module.loan_service_secret.secret_arn
}

# RDS 
output "loan_rds_endpoint" {
  value = module.loan_rds.db_endpoint
}

output "loan_rds_db_name" {
  value = module.loan_rds.db_name
}

output "loan_service_secret_arn" {
  value = module.loan_service_secret.secret_arn
}
