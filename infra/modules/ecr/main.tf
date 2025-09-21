resource "aws_ecr_repository" "this" {
  name                 = "${var.project}/${var.service_name}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project = var.project
    Service = var.service_name
  }
}
