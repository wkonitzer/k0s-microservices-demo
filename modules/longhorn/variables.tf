variable "provision" {
  description = "Module provision outputs including hosts"
  type = list(object({
    role = string
    ssh  = object({
      address  = string
      user     = string
      keyPath  = string
    })
  }))
}

variable "domain_name" {
  description = "The domain name for the microservice."
  type        = string
}

variable "server_name" {
  description = "The server name or subdomain for the microservice."
  type        = string
  default     = "longhorn"
}

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
