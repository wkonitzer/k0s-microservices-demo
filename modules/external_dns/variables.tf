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

