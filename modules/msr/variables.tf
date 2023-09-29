variable "domain_name" {
  description = "The domain name for the microservice."
  type        = string
}

variable "server_name" {
  description = "The server name or subdomain for the microservice."
  type        = string
  default     = "msr"
}

variable "license_file_path" {
  description = "Path to the Docker Enterprise license file."
  type        = string
  default     = null
}
