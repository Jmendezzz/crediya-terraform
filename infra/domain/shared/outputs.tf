output "ecs_execution_role_arn" {
  description = "ARN of the ECS task execution role (used for logs and ECR)"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "jwt_secret_arn" {
  description = "ARN of the global JWT secret"
  value       = module.jwt_secret.secret_arn
}
