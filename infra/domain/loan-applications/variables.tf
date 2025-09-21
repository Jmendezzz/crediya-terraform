variable "project" {
  description = "Nombre del proyecto para etiquetar recursos"
  type        = string
}

variable "private_subnets" {
  description = "Subnets privadas para el RDS"
  type        = list(string)
}

variable "rds_sg_id" {
  description = "Security Group ID para RDS"
  type        = string
}

variable "jwt_secret_arn" {
    description = "JWT ARN"
    type = string

}
