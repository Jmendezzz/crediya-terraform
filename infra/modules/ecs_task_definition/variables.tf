variable "family" {
  description = "Nombre de la familia (task definition)"
  type        = string
}

variable "container_name" {
  description = "Nombre del contenedor"
  type        = string
}

variable "image" {
  description = "Imagen de ECR"
  type        = string
}

variable "cpu" {
  description = "CPU units (ej: 512)"
  type        = string
}

variable "memory" {
  description = "Memoria en MiB (ej: 1024)"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN del rol de ejecución para ECS"
  type        = string
}

variable "task_role_arn" {
  description = "ARN del rol de la tarea."
  type = string
}

variable "region" {
  description = "Región AWS"
  default = "us-east-1"
  type        = string
}

variable "environment" {
  description = "Variables de entorno no sensibles"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "secrets" {
  description = "Secrets desde Secrets Manager"
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
}

variable "port_mappings" {
  description = "Puertos del contenedor"
  type = list(object({
    containerPort = number
    hostPort      = number
    protocol      = string
  }))
  default = []
}
