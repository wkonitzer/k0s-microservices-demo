variable "mke_cluster_config" {
  description = "Content of the MKE cluster configuration for Launchpad."
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