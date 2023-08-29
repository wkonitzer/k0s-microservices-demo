variable "lb_address_range" {
  description = "The IP range for the load balancer address pool"
  type        = string
}

variable "chart_version" {
  description = "The MetalLB chart version to install."
  type        = string
  default     = null
}

variable "kubeconfig_content" {
  description = "The content of the kubeconfig file."
  type        = string
  sensitive   = true
}