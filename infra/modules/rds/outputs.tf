output "auth_db_endpoint" {
  value = aws_db_instance.auth.endpoint
}

output "loan_db_endpoint" {
  value = aws_db_instance.loan.endpoint
}

output "db_subnet_group" {
  value = aws_db_subnet_group.this.name
}
