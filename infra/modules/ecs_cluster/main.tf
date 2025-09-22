resource "aws_ecs_cluster" "this" {
  name = "${var.project}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Project = var.project
  }
}
