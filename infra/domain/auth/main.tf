# ==========================
# RDS Instance
# ==========================
resource "random_password" "auth_db_password" {
  length  = 20
  special = true
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
  secret_name = "auth-service-secret"

  secret_values = {
    AUTH_SERVICE_DB_USERNAME = "admin"
    AUTH_SERVICE_DB_PASSWORD = random_password.auth_db_password.result
    JWT_SECRET_ARN = var.jwt_secret_arn
  }
}
