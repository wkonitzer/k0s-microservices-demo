variable "chart_version" {
  description = "The MetalLB chart version to install."
  type        = string
  default     = null
}

variable "license_file_path" {
  description = "Path to the Docker Enterprise license file."
  type        = string
  default     = null
}