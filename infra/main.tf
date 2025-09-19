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
  source                      = "./modules/sqs"
  project                     = var.project
  name                        = "loan-application-auto-validation-completed"
  dlq_arn                     = module.loan_application_auto_validation_completed_dlq.queue_arn
}

module "loan_application_auto_validation_requested" {
  source                      = "./modules/sqs"
  project                     = var.project
  name                        = "loan-application-auto-validation-requested"
}

module "loan_application_state_changed" {
  source                      = "./modules/sqs"
  project                     = var.project
  name                        = "loan-application-state-changed"
}
