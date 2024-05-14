output "first_manager_ip" {
  description = "IP Address of the first controller"
  value = try(element([for host in var.provision : host.ssh.address if host.role == "controller"], 0), null)
}