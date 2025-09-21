variable "project" {
  type        = string
  description = "Nombre del proyecto"
}

variable "service_name" {
  type        = string
  description = "Nombre del servicio (ej: auth, loan)"
}

variable "private_subnets" {
  type        = list(string)
  description = "Subnets privadas para RDS"
}

variable "rds_sg_id" {
  type        = string
  description = "Security group para RDS"
}

variable "db_username" {
  type        = string
  description = "Usuario administrador de la BD"
}

variable "db_password" {
  type        = string
  description = "Password administrador de la BD"
}

variable "db_name" {
  type        = string
  description = "Nombre de la base de datos"
}
