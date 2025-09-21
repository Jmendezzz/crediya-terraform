# Queues
module "daily_report_metric_generated" {
  source  = "../../modules/sqs"
  project = var.project
  name    = "daily-report-metric-generated"
}


# IAM
module "iam_report_service" {
  source       = "../../modules/iam"
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
        Resource = module.loan_applications.loan_application_approved_arn
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