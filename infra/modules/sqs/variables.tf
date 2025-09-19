variable "project" {
  description = "Nombre del proyecto"
  type        = string
}

variable "name" {
  description = "Nombre de la cola"
  type        = string
}

variable "visibility_timeout_seconds" {
  description = "Tiempo de invisibilidad (cuando un consumidor toma el mensaje)"
  type        = number
  default     = 30
}

variable "message_retention_seconds" {
  description = "Tiempo de retención de mensajes en la cola"
  type        = number
  default     = 3600 
}

variable "delay_seconds" {
  description = "Retraso inicial en la entrega de mensajes"
  type        = number
  default     = 0
}

variable "receive_wait_time_seconds" {
  description = "Tiempo máximo que espera ReceiveMessage (long polling)"
  type        = number
  default     = 10
}

variable "max_message_size" {
  description = "Tamaño máximo del mensaje en bytes"
  type        = number
  default     = 262144 # 256 KiB
}

variable "dlq_arn" {
  description = "ARN de la Dead Letter Queue (opcional)"
  type        = string
  default     = null
}

variable "max_receive_count" {
  description = "Número de reintentos antes de mandar a la DLQ"
  type        = number
  default     = 5
}
