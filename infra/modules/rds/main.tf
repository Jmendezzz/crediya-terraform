# Subnet Group para RDS
resource "aws_db_subnet_group" "this" {
  name       = "${var.project}-db-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name = "${var.project}-db-subnet-group"
  }
}

# Instancia RDS para Auth Service
resource "aws_db_instance" "auth" {
  identifier              = "${var.project}-auth-service"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t4g.micro"
  allocated_storage       = 20
  db_name                 = "authdb"
  username                = var.db_username
  password                = var.db_password
  port                    = 3306

  vpc_security_group_ids  = [var.rds_sg_id]
  db_subnet_group_name    = aws_db_subnet_group.this.name

  skip_final_snapshot     = true
  deletion_protection     = false
  publicly_accessible     = false

  tags = {
    Name = "${var.project}-auth-service"
  }
}

# Instancia RDS para Loan Service
resource "aws_db_instance" "loan" {
  identifier              = "${var.project}-loan-service"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t4g.micro"
  allocated_storage       = 20
  db_name                 = "loandb"
  username                = var.db_username
  password                = var.db_password
  port                    = 3306

  vpc_security_group_ids  = [var.rds_sg_id]
  db_subnet_group_name    = aws_db_subnet_group.this.name

  skip_final_snapshot     = true
  deletion_protection     = false
  publicly_accessible     = false

  tags = {
    Name = "${var.project}-loan-service"
  }
}
