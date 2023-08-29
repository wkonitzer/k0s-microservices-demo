terraform {
  required_providers {
    equinix = {
      source  = "equinix/equinix"
    }
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "local_file" "ssh_private_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "ssh_keys/${var.cluster_name}.pem"
  provisioner "local-exec" {
    command = "chmod 0600 ${local_file.ssh_private_key.filename}"
  }
}

resource "local_file" "ssh_public_key" {
  content  = tls_private_key.ssh_key.public_key_openssh
  filename = "ssh_keys/${var.cluster_name}.pub"
  provisioner "local-exec" {
    command = "chmod 0600 ${local_file.ssh_public_key.filename}"
  }
}  

resource "equinix_metal_project_ssh_key" "ssh_key_object" {
  name       = "${var.cluster_name}_key"
  public_key = tls_private_key.ssh_key.public_key_openssh
  project_id = var.project_id
}

data "equinix_metal_project_ssh_key" "infra_ssh" {
  depends_on = [equinix_metal_project_ssh_key.ssh_key_object]
  search     = equinix_metal_project_ssh_key.ssh_key_object.name
  project_id = var.project_id
}

resource "equinix_metal_vlan" "vlan" {
  metro       = var.metro
  description = "${var.cluster_name}.vlan"
  project_id  = var.project_id
}

resource "equinix_metal_reserved_ip_block" "public_ip_block" {
  count       = var.request_ip_block ? 1 : 0  
  project_id  = var.project_id
  quantity    = var.ip_block_size              
  type        = "public_ipv4"
  metro       = var.metro                     
  description = "Public IP Block for ${var.cluster_name}"
}

resource "equinix_metal_gateway" "gateway" {
  project_id        = var.project_id
  vlan_id           = equinix_metal_vlan.vlan.id
  ip_reservation_id = equinix_metal_reserved_ip_block.public_ip_block[0].id

  provisioner "local-exec" {
    when    = destroy
    command = "sleep 20"
  }
}

