# ==========================
# Random password for RDS
# ==========================
resource "random_password" "loan_db_password" {
  length  = 20
  special = true
}

# ==========================
# RDS Instance
# ==========================
module "loan_rds" {
  source          = "../../modules/rds"
  project         = var.project
  private_subnets = var.private_subnets
  rds_sg_id       = var.rds_sg_id

  db_username     = "admin" 
  db_password     = random_password.loan_db_password.result
}

# ==========================
# SQS Queues
# ==========================
module "loan_application_approved" {
  source  = "../../modules/sqs"
  project = var.project
  name    = "loan-application-approved"
}

module "loan_application_auto_validation_completed_dlq" {
  source  = "../../modules/sqs"
  project = var.project
  name    = "loan-application-auto-validation-completed-dlq"
}

module "loan_application_auto_validation_completed" {
  source  = "../../modules/sqs"
  project = var.project
  name    = "loan-application-auto-validation-completed"
  dlq_arn = module.loan_application_auto_validation_completed_dlq.queue_arn
}

module "loan_application_auto_validation_requested" {
  source  = "../../modules/sqs"
  project = var.project
  name    = "loan-application-auto-validation-requested"
}

module "loan_application_state_changed" {
  source  = "../../modules/sqs"
  project = var.project
  name    = "loan-application-state-changed"
}

# ==========================
# IAM
# ==========================
module "iam_loan_service" {
  source       = "../../modules/iam"
  project      = var.project
  service_name = "loan"
  user_name    = "crediya-loan-application-service"

  inline_policies = {
    "send-to-loan-request-validation-queue" = {
      Version = "2012-10-17"
      Statement = [{
        Effect   = "Allow"
        Action   = ["sqs:SendMessage"]
        Resource = module.loan_application_auto_validation_requested.queue_arn
      }]
    }

    "send-to-loan-application-approved-queue" = {
      Version = "2012-10-17"
      Statement = [{
        Effect   = "Allow"
        Action   = ["sqs:SendMessage"]
        Resource = module.loan_application_approved.queue_arn
      }]
    }

    "read-from-loan-application-auto-validation-completed" = {
      Version = "2012-10-17"
      Statement = [{
        Effect   = "Allow"
        Action   = ["sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"]
        Resource = module.loan_application_auto_validation_completed.queue_arn
      }]
    }
  }
}


# ==========================
# Secrets manager
# ==========================
module "loan_service_secret" {
  source      = "../../modules/secrets_manager"
  project     = var.project
  secret_name = "loan-service-secret"

  secret_values = {
    LOAN_REQUEST_SERVICE_DB_USERNAME = "admin"
    LOAN_REQUEST_SERVICE_DB_PASSWORD = random_password.loan_db_password.result

    JWT_SECRET_ARN = var.jwt_secret_arn

    LOAN_APPLICATION_STATUS_CHANGED_QUEUE            = module.loan_application_state_changed.queue_url
    LOAN_APPLICATION_AUTO_VALIDATION_REQUESTED_QUEUE = module.loan_application_auto_validation_requested.queue_url
    LOAN_APPLICATION_APPROVED_QUEUE                  = module.loan_application_approved.queue_url
    LOAN_APPLICATION_AUTO_VALIDATION_COMPLETED_QUEUE = module.loan_application_auto_validation_completed.queue_url

    AWS_ACCESS_KEY_ID     = module.iam_loan_service.access_key_id
    AWS_SECRET_ACCESS_KEY = module.iam_loan_service.secret_access_key
  }
}