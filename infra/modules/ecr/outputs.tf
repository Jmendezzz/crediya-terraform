output "repository_url" {
  description = "Repo URL"
  value       = aws_ecr_repository.this.repository_url
}

output "repository_arn" {
  description = "Repo ARN"
  value       = aws_ecr_repository.this.arn
}
