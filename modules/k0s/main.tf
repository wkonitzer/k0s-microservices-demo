resource "local_file" "k0s_config" {
  filename = "${path.root}/k0sctl.yaml"
  content  = var.k0s_cluster_config

  provisioner "local-exec" {
    when    = destroy
    command = "rm -f ${self.filename}"
  }
}

locals {
  all_ips_list = [for host in var.provision : host.ssh.address]
}

resource "null_resource" "remove_known_hosts" {
  provisioner "local-exec" {
    command = <<EOT
      for ip in ${join(" ", local.all_ips_list)}; do
        ssh-keygen -R $ip
      done
    EOT
  }
}

resource "null_resource" "run_k0sctl_apply" {
  depends_on = [local_file.k0s_config]

  provisioner "local-exec" {
    command = <<EOT
      k0sctl apply --config ${local_file.k0s_config.filename}
      sleep 70
    EOT  
  }

  triggers = {
    my_file_content = local_file.k0s_config.content
  }
}

resource "null_resource" "set_kubeconfig_and_permissions" {
  depends_on = [null_resource.run_k0sctl_apply]

  provisioner "local-exec" {
    command = <<EOT
      k0sctl kubeconfig > ${path.root}/kubeconfig
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -f ${path.root}/kubeconfig"
  }
}