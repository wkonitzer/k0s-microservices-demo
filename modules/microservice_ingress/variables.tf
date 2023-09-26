variable "domain_name" {
  description = "The domain name for the microservice."
  type        = string
}

variable "server_name" {
  description = "The server name or subdomain for the microservice."
  type        = string
}

variable "namespace" {
  description = "The namespace to query the ingress from"
  type        = string
}

