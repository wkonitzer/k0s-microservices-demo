variable "namespace" {
  description = "Namespace for Caddy"
  default     = "caddy-system"
}

variable "email" {
  description = "Email for Caddy"
  type        = string
}
