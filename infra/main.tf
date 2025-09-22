provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "./modules/vpc"
  project = var.project
}

module "security_groups" {
  source    = "./modules/security_groups"
  project   = var.project
  vpc_id    = module.vpc.vpc_id
  rds_port  = 3306
  vpc_cidrs = [module.vpc.cidr_block]
}

module "alb" {
  source          = "./modules/alb"
  project         = var.project
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  sg_id           = module.security_groups.alb_sg_id
}

module "ecs_cluster" {
  source  = "./modules/ecs_cluster"
  project = var.project
}



# module "loan_applications" {
#   source          = "./domain/loan_applications"
#   project         = var.project
#   private_subnets = module.vpc.private_subnets
#   rds_sg_id       = module.security_groups.rds_sg_id
#   jwt_secret_arn  = module.shared.jwt_secret_arn
# }

# ==========================
# Shared resources
# ==========================
module "shared" {
  source  = "./domain/shared"
  project = var.project
}

# ==========================
# Auth domain
# ==========================
module "auth" {
  source             = "./domain/auth"
  project            = var.project
  private_subnets    = module.vpc.private_subnets
  rds_sg_id          = module.security_groups.rds_sg_id
  jwt_secret_arn     = module.shared.jwt_secret_arn
  execution_role_arn = module.shared.ecs_execution_role_arn
}


# module "report_service_secret" {
#   source      = "./modules/secrets_manager"
#   project     = var.project
#   secret_name = "report-service-secret"
#   secret_values = {
#     JWT_SECRET                      = "vDh8mTjeVz..."
#     APPROVED_LOANS_DYNAMO_TABLE     = "approved_loans"
#     LOAN_APPLICATION_APPROVED_QUEUE = "https://sqs.us-east-1.amazonaws.com/123456789012/loan-application-approved"
#     AWS_ACCESS_KEY_ID               = "AKIA..."
#     AWS_SECRET_ACCESS_KEY           = "svskPQQ..."
#   }
# }
