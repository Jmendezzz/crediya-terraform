output "ecs_sg_id" {
  value = aws_security_group.ecs.id
}

output "alb_sg_id" {
  value = aws_security_group.alb.id
}

output "api_gateway_sg_id" {
  value = aws_security_group.api_gateway.id
}

output "rds_sg_id" {
  value = aws_security_group.rds.id
}

output "endpoints_sg_id" {
  value = aws_security_group.endpoints.id
}
