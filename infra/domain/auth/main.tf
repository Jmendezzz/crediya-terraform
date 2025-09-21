# ==========================
# RDS Instance
# ==========================
resource "random_password" "auth_db_password" {
  length           = 20
  special          = true
  override_special = "!#$%^&*()-_=+[]{}<>:?"
}

module "auth_rds" {
  source          = "../../modules/rds"
  project         = var.project
  service_name    = "auth"
  private_subnets = var.private_subnets
  rds_sg_id       = var.rds_sg_id

  db_username     = "admin"
  db_password     = random_password.auth_db_password.result
  db_name         = "authdb"
}

# ==========================
# Secrets Manager
# ==========================
module "auth_service_secret" {
  source      = "../../modules/secrets_manager"
  project     = var.project
  secret_name = "${var.project}-auth-service-secret"

  secret_values = {
    AUTH_SERVICE_DB_USERNAME = "admin"
    AUTH_SERVICE_DB_PASSWORD = random_password.auth_db_password.result
    JWT_SECRET_ARN           = var.jwt_secret_arn
  }
}

# ==========================
# ECR Repo
# ==========================
module "auth_ecr" {
  source       = "../../modules/ecr"
  project      = var.project
  service_name = "${var.project}-auth-service"
}

# ==========================
# IAM Task Role (Auth)
# ==========================
resource "aws_iam_role" "auth_task_role" {
  name = "${var.project}-auth-task-role"

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

resource "aws_iam_role_policy" "auth_task_policy" {
  name = "${var.project}-auth-task-policy"
  role = aws_iam_role.auth_task_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = module.auth_service_secret.secret_arn
      }
    ]
  })
}

# ==========================
# ECS Task Definition
# ==========================
module "auth_task_definition" {
  source             = "../../modules/ecs_task_definition"
  family             = "${var.project}-auth-service-task"
  container_name     = "${var.project}-auth-service"
  image              = "${module.auth_ecr.repository_url}:latest"
  cpu                = "512"
  memory             = "1024"

  execution_role_arn = var.execution_role_arn
  task_role_arn      = aws_iam_role.auth_task_role.arn

  environment = [
    { name = "AUTH_SERVICE_DB_PORT",  value = "3306" },
    { name = "JWT_EXPIRATION_MS",     value = "3600000" },
    { name = "AUTH_SERVICE_DB_NAME",  value = "authdb" },
    { name = "AUTH_SERVICE_DB_HOST",  value = module.auth_rds.db_endpoint }
  ]

  secrets = [
    { name = "AUTH_SERVICE_DB_USERNAME", valueFrom = "${module.auth_service_secret.secret_arn}:AUTH_SERVICE_DB_USERNAME::" },
    { name = "AUTH_SERVICE_DB_PASSWORD", valueFrom = "${module.auth_service_secret.secret_arn}:AUTH_SERVICE_DB_PASSWORD::" },
    { name = "JWT_SECRET",               valueFrom = "${module.auth_service_secret.secret_arn}:JWT_SECRET_ARN::" }
  ]

  port_mappings = [
    {
      containerPort = 8080
      hostPort      = 8080
      protocol      = "tcp"
    }
  ]
}
