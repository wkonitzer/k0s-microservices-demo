resource "local_file" "launchpad_config" {
  filename = "${path.root}/launchpad.yaml"
  content  = var.mke_cluster_config

  provisioner "local-exec" {
    when    = destroy
    command = "rm -f ${self.filename}"
  }
}

resource "null_resource" "remove_known_hosts" {
  provisioner "local-exec" {
    command = <<EOT
      for ip in ${join(" ", var.all_ips_list)}; do
        ssh-keygen -R $ip
      done
    EOT
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

resource "null_resource" "run_launchpad_apply" {
  depends_on = [local_file.launchpad_config]

  provisioner "local-exec" {
    command = <<EOT
      launchpad apply --config ${local_file.launchpad_config.filename}
      sleep 240
    EOT  
  }

  triggers = {
    my_file_content = local_file.launchpad_config.content
  }
}

resource "null_resource" "set_kubeconfig_and_permissions" {
  depends_on = [null_resource.run_launchpad_apply]

  provisioner "local-exec" {
    command = <<EOT
      kubeconfig_file=$(launchpad client-config | grep "Successfully wrote client bundle to" | awk '{print $NF}')
      cp $kubeconfig_file/kube.yml ${path.root}/kubeconfig
    EOT
  }

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -f ${path.root}/kubeconfig"
  }
}

resource "local_file" "setup_complete_flag" {
  filename = "${path.module}/.launchpad_setup_complete"
  content  = "This file indicates that the launchpad_setup module has completed."

  provisioner "local-exec" {
    when    = destroy
    command = "rm -f ${self.filename}"
  }
}