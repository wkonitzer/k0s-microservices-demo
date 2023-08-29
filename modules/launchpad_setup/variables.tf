variable "mke_cluster_config" {
  description = "Content of the MKE cluster configuration for Launchpad."
  type        = string
}

variable "all_ips_list" {
  description = "List of all IPs"
  type        = list(string)
}