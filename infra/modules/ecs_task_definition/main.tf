resource "aws_ecs_task_definition" "this" {
  family                   = var.family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn


  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.image
      essential = true

      portMappings = var.port_mappings

      environment = [
        for env in var.environment : {
          name  = env.name
          value = env.value
        }
      ]

      secrets = [
        for s in var.secrets : {
          name      = s.name
          valueFrom = s.valueFrom
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.family}"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}
