variable "project" {
  description = "Project name"
  type        = string
}

variable "secret_name" {
  description = "Name of the secret"
  type        = string
}

variable "secret_values" {
  description = "Map of key/values to store in the secret"
  type        = map(string)
}
