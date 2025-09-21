resource "aws_iam_user" "this" {
  name = var.user_name
  tags = {
    Project = var.project
    Service = var.service_name
  }
}

resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}

# Attach policies
resource "aws_iam_user_policy" "inline" {
  for_each = var.inline_policies

  name   = each.key
  user   = aws_iam_user.this.name
  policy = jsonencode(each.value)
}

output "user_name" {
  value = aws_iam_user.this.name
}

output "access_key_id" {
  value     = aws_iam_access_key.this.id
  sensitive = true
}

output "secret_access_key" {
  value     = aws_iam_access_key.this.secret
  sensitive = true
}
