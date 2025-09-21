# ==========================
# Global JWT secret
# ==========================
resource "random_password" "jwt_secret" {
  length  = 32
  special = false
}

module "jwt_secret" {
  source      = "../../modules/secrets_manager"
  project     = var.project
  secret_name = "${var.project}-global-jwt-secret"

  secret_values = {
    JWT_SECRET = random_password.jwt_secret.result
  }
}

# ==========================
# ECS Execution Role
# Used by all ECS tasks to pull images from ECR and send logs to CloudWatch
# ==========================
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.project}-ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
