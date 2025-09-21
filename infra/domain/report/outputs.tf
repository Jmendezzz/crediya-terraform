output "daily_report_metric_generated_arn" {
  description = "ARN de la cola daily_report_metric_generated"
  value       = module.daily_report_metric_generated.queue_arn
}

output "daily_report_metric_generated_url" {
  description = "URL de la cola daily_report_metric_generated"
  value       = module.daily_report_metric_generated.queue_url
}
