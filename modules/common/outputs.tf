output "ssh_key" {
  description = "ID of the infra SSH key."
  value       = data.equinix_metal_project_ssh_key.infra_ssh.id
}

output "vxlan" {
  description = "The VXLAN of the VLAN."
  value       = equinix_metal_vlan.vlan.vxlan
}

output "reserved_ip_cidr" {
  description = "List of reserved public IP addresses."
  value       = equinix_metal_reserved_ip_block.public_ip_block[0].cidr_notation
  depends_on  = [equinix_metal_reserved_ip_block.public_ip_block]
}

output "reserved_ip_addresses" {
  description = "The list of IP addresses from the reserved IP block."
  value       = equinix_metal_reserved_ip_block.public_ip_block[0].address
}

output "private_key_path" {
  description = "Path to the SSH private key file"
  value       = local_file.ssh_private_key.filename
}
