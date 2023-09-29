variable "admin_username" {
  description = "The admin username for MKE"
  type        = string
  default     = "admin"
}

variable "admin_password" {
  description = "The password for MKE"
  type        = string
}

variable "host" {
  description = "The MKE Host"
  type        = string
}