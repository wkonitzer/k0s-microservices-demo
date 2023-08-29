variable "cluster_name" {}

variable "project_id" {
  type        = string
}

# Machines configuration
variable "machine_size" {
  default = "c3.small.x86"
  type    = string
}

variable "metros" {
  type = list(object({
    reserved_hardware = optional(list(object({
      id   = string
      plan = string
    })))
    metro                  = string
    #vlans_amount           = number
    # TODO(eromanova): define defaults for deploy_seed and router_as_seed variables once terraform 1.3 available
    #deploy_seed            = optional(bool)
    #router_as_seed         = optional(bool)
    #enable_internet_access = optional(bool)
    #routers_dhcp           = optional(list(string))
  }))

  description = <<EOT
example of object:
"metros": [
  {
    "metro": "sv",
    "reserved_hardware": [
        {
            "id": "a5bfe903-c4cb-47e6-b321-b56d16be51f7",
            "plan": "n2.medium.x86"
        },
        {
            "id": "1269e7ab-dd60-4b49-8ae3-b0c9d49dce5c",
            "plan": "c3.small.x86"
        }
    ],
  },
]
EOT

  validation {
    condition = alltrue([
      for o in var.metros : o.metro != ""
    ])
    error_message = "Metro should be specified explicitly"
  }
}

variable "operating_system" {
  type    = string
  default = "ubuntu_20_04"
}

variable "billing_cycle" {
  default = "hourly"
  type    = string
}

variable "machine_count" {
  description = "Number of nodes to create."
  type        = number
  default     = 3
}

variable "ssh_key" {
  description = "SSH key ID for the machines."
  type        = string
}

variable "hostname" {
  description = "Hostname prefix for the machines."
  type        = string
}

variable "vlan" {
  description = "The VXLAN of the VLAN from the common module."
  type        = number
}

variable "reserved_ip_addresses" {
  description = "The list of IP addresses from the reserved IP block."
  type        = list(string)
  default     = []
}

variable "ssh_private_key_path" {
  description = "Path to the SSH private key file"
  type        = string
}

variable "reserved_ip_cidr" {
  description = "The CIDR notation of the reserved IP block from the common module."
  type        = string
}

variable "ip_addresses" {
  description = "A map of IP addresses for the machine nodes"
  type        = map(string)
  default     = {}
}