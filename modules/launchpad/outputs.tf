output "first_manager_ip" {
  description = "IP Address of the first manager"
  value = try(element([for host in var.provision : host.ssh.address if host.role == "manager"], 0), null)
}
