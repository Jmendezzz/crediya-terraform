resource "aws_db_subnet_group" "this" {
  name       = "${var.project}-${var.service_name}-db-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name = "${var.project}-${var.service_name}-db-subnet-group"
  }
}

resource "aws_db_instance" "this" {
  identifier              = "${var.project}-${var.service_name}-db"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t4g.micro"
  allocated_storage       = 20
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  port                    = 3306

  vpc_security_group_ids  = [var.rds_sg_id]
  db_subnet_group_name    = aws_db_subnet_group.this.name

  skip_final_snapshot     = true
  deletion_protection     = false
  publicly_accessible     = false

  tags = {
    Project = var.project
    Name    = "${var.project}-${var.service_name}-db"
  }
}
