variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
}

variable "mcr_version" {
  description = "The version of Mirantis Container Runtime"
  type        = string
}

variable "admin_password" {
  description = "The admin password for Mirantis Kubernetes Engine"
  type        = string
}

variable "mke_version" {
  description = "The version of Mirantis Kubernetes Engine"
  type        = string
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

variable "license_file_path" {
  description = "Path to the Docker Enterprise license file."
  type        = string
  default     = null
}

