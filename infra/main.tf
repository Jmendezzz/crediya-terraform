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
  rds_port  = 3306 # Change it later when RDS module created
  vpc_cidrs = [module.vpc.cidr_block]
}

module "alb" {
  source          = "./modules/alb"
  project         = var.project
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  sg_id           = module.security_groups.alb_sg_id
}

module "daily_report_metric_generated" {
  source  = "./modules/sqs"
  project = var.project
  name    = "daily-report-metric-generated"
}

module "loan_application_approved" {
  source  = "./modules/sqs"
  project = var.project
  name    = "loan-application-approved"
}

module "loan_application_auto_validation_completed_dlq" {
  source  = "./modules/sqs"
  project = var.project
  name    = "loan-application-auto-validation-completed-dlq"
}

module "loan_application_auto_validation_completed" {
  source  = "./modules/sqs"
  project = var.project
  name    = "loan-application-auto-validation-completed"
  dlq_arn = module.loan_application_auto_validation_completed_dlq.queue_arn
}

module "loan_application_auto_validation_requested" {
  source  = "./modules/sqs"
  project = var.project
  name    = "loan-application-auto-validation-requested"
}

module "loan_application_state_changed" {
  source  = "./modules/sqs"
  project = var.project
  name    = "loan-application-state-changed"
}


#IAM
module "iam_loan_service" {
  source       = "./modules/iam"
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

module "iam_report_service" {
  source       = "./modules/iam"
  project      = var.project
  service_name = "report"
  user_name    = "crediya-report-service"

  inline_policies = {
    "send-to-daily-report-metric-generated-queue" = {
      Version = "2012-10-17"
      Statement = [{
        Effect   = "Allow"
        Action   = ["sqs:SendMessage"]
        Resource = module.daily_report_metric_generated.queue_arn
      }]
    }

    "read-from-loan-application-approved-queue" = {
      Version = "2012-10-17"
      Statement = [{
        Effect   = "Allow"
        Action   = ["sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"]
        Resource = module.loan_application_approved.queue_arn
      }]
    }

    "manage-approved-loans-dynamo-table" = {
      Version = "2012-10-17"
      Statement = [{
        Effect   = "Allow"
        Action   = ["dynamodb:PutItem", "dynamodb:UpdateItem", "dynamodb:GetItem"]
        Resource = aws_dynamodb_table.approved_loans.arn
      }]
    }
  }
}


# Secret: auth-service
module "auth_service_secret" {
  source      = "./modules/secrets_manager"
  project     = var.project
  secret_name = "auth-service-secret"
  secret_values = {
    AUTH_SERVICE_DB_USERNAME = "admin"
    AUTH_SERVICE_DB_PASSWORD = "SuperSecret123!"
    JWT_SECRET               = "vDh8mTjeVz..."
  }
}

module "loan_service_secret" {
  source      = "./modules/secrets_manager"
  project     = var.project
  secret_name = "loan-service-secret"
  secret_values = {
    LOAN_REQUEST_SERVICE_DB_USERNAME                 = "admin"
    LOAN_REQUEST_SERVICE_DB_PASSWORD                 = "v2GQ2sWk..."
    JWT_SECRET                                       = "vDh8mTjeVz..."
    LOAN_APPLICATION_STATUS_CHANGED_QUEUE            = "https://sqs.us-east-1.amazonaws.com/123456789012/loan-application-state-changed"
    LOAN_APPLICATION_AUTO_VALIDATION_REQUESTED_QUEUE = "https://sqs.us-east-1.amazonaws.com/123456789012/loan-application-auto-validation-requested"
    LOAN_APPLICATION_APPROVED_QUEUE                  = "https://sqs.us-east-1.amazonaws.com/123456789012/loan-application-approved"
    LOAN_APPLICATION_AUTO_VALIDATION_COMPLETED_QUEUE = "https://sqs.us-east-1.amazonaws.com/123456789012/loan-application-auto-validation-completed"
    AWS_ACCESS_KEY_ID                                = "AKIA..."
    AWS_SECRET_ACCESS_KEY                            = "84EZJ..."
  }
}

module "report_service_secret" {
  source      = "./modules/secrets_manager"
  project     = var.project
  secret_name = "report-service-secret"
  secret_values = {
    JWT_SECRET                      = "vDh8mTjeVz..."
    APPROVED_LOANS_DYNAMO_TABLE     = "approved_loans"
    LOAN_APPLICATION_APPROVED_QUEUE = "https://sqs.us-east-1.amazonaws.com/123456789012/loan-application-approved"
    AWS_ACCESS_KEY_ID               = "AKIA..."
    AWS_SECRET_ACCESS_KEY           = "svskPQQ..."
  }
}


module "rds" {
  source          = "./modules/rds"
  project         = var.project
  private_subnets = module.vpc.private_subnets
  rds_sg_id       = module.security_groups.rds_sg_id
  db_username     = "admin"
  db_password     = "SuperSecret123!"
}
