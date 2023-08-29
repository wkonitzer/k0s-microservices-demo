output "public_ips" {
  description = "List of public IPs for the machines."
  value       = [for instance in equinix_metal_device.machine : instance.access_public_ipv4]
}
