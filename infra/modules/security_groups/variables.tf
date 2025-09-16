variable "project" {
  description = "Project prefix"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "rds_port" {
  description = "RDS port"
  type        = number
  default     = 5432
}

variable "vpc_cidrs" {
  description = "CIDRs of VPC for endpoints access"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}
