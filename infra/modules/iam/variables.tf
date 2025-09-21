variable "project" {
  description = "Project name"
  type        = string
}

variable "service_name" {
  description = "Service associated to the IAM user"
  type        = string
}

variable "user_name" {
  description = "IAM username"
  type        = string
}

variable "inline_policies" {
  description = "Inline IAM policies (map of JSON)"
  type        = map(any)
  default     = {}
}
