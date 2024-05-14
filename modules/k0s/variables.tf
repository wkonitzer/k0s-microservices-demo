variable "k0s_cluster_config" {
  description = "Content of the k0s cluster configuration for k0sctl."
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