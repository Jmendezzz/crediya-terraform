resource "aws_sqs_queue" "this" {
  name                        = var.name
  visibility_timeout_seconds  = var.visibility_timeout_seconds
  message_retention_seconds   = var.message_retention_seconds
  delay_seconds               = var.delay_seconds
  receive_wait_time_seconds   = var.receive_wait_time_seconds
  max_message_size            = var.max_message_size

  sqs_managed_sse_enabled = true

  redrive_policy = var.dlq_arn != null ? jsonencode({
    deadLetterTargetArn = var.dlq_arn
    maxReceiveCount     = var.max_receive_count
  }) : null

  tags = {
    Project = var.project
    Name    = var.name
  }
}
