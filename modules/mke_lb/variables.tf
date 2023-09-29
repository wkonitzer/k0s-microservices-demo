variable "domain_name" {
  description = "The domain name for the microservice."
  type        = string
}

variable "server_name" {
  description = "The server name or subdomain for the microservice."
  type        = string
  default     = "mke"
}

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