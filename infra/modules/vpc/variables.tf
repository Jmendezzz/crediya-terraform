variable "project" {
  description = "Nombre del proyecto para tags"
  type        = string
}

variable "cidr_block" {
  description = "CIDR para la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Lista de subnets públicas"
  type        = list(string)
}

variable "private_subnets" {
  description = "Lista de subnets privadas"
  type        = list(string)
}

variable "azs" {
  description = "Availability Zones para las subnets"
  type        = list(string)
}
