module "jwt_secret" {
  source      = "../../modules/secrets_manager"
  project     = var.project
  secret_name = "global-jwt-secret"

  secret_values = {
    JWT_SECRET = random_password.jwt_secret.result
  }
}

resource "random_password" "jwt_secret" {
  length  = 32
  special = false
}
