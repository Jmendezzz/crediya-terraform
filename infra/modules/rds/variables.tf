variable "project" {
  type        = string
  description = "Project name prefix"
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnets for the DB subnet group"
}

variable "rds_sg_id" {
  type        = string
  description = "Security group for RDS instances"
}

variable "db_username" {
  type        = string
  description = "Master username for RDS"
}

variable "db_password" {
  type        = string
  description = "Master password for RDS"
  sensitive   = true
}
