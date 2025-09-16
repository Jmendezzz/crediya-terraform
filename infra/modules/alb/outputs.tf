output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "target_groups" {
  value = {
    auth   = aws_lb_target_group.auth.arn
    loan   = aws_lb_target_group.loan.arn
    report = aws_lb_target_group.report.arn
  }
}
