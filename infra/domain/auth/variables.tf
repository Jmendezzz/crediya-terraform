variable "project" {
  description = "Nombre del proyecto"
  type        = string
}

variable "private_subnets" {
  description = "Subnets privadas para instancias RDS"
  type        = list(string)
}

variable "rds_sg_id" {
  description = "Security Group ID para RDS"
  type        = string
}

variable "jwt_secret_arn" {
  description = "ARN del secret global de JWT"
  type        = string
}
