# Project configuration
# required to export METAL_AUTH_TOKEN=XXXX

variable "project_id" {
  type        = string
  description = <<EOT
ID of your Project in Equinix Metal,
possible to handle as environment variable:
export TF_VAR_project_id="XXXXXXXXXXX"
EOT
}

variable "cluster_name" {
  default = "mke"
}

variable "master_count" {
  default = 3
}

variable "worker_count" {
  default = 3
}

variable "metros" {
  description = "List of metros and their reserved hardware"
  type = list(object({
    metro            = string
    reserved_hardware = list(object({
      id   = string
      plan = string
    }))
  }))
}

variable "mke_version" {
  default = "3.7.0"
}

variable "admin_password" {
  default = "orcaorcaorca"
}

variable "license_file_path" {
  description = "Path to the Docker Enterprise license file"
  type        = string
  default     = null
}

variable "mcr_version" {
  default = "23.0.6"
}

variable "email" {
  description = "The email address to be used with Ingress controllers"
  type        = string
}

variable "godaddy_api_key" {
  description = "API key for GoDaddy provider"
  type        = string
  sensitive   = true
}

variable "godaddy_api_secret" {
  description = "API secret for GoDaddy provider"
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "The domain name for the microservice."
  type        = string
}

variable "server_name" {
  description = "The server name or subdomain for the microservice."
  type        = string
}