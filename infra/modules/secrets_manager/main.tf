resource "aws_secretsmanager_secret" "this" {
  name       = var.secret_name
  description = "Secret for ${var.secret_name}"
  tags = {
    Project = var.project
  }
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = jsonencode(var.secret_values)
}
