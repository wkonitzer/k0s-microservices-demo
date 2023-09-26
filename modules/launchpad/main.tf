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

#  triggers = {
#    always_run = "${timestamp()}"
#  }  
}

resource "launchpad_config" "cluster" {
  skip_destroy = true

  metadata {
    name = var.cluster_name
  }

  spec {
    cluster {
      prune = true
    }

    dynamic "host" {
      for_each = var.provision
      content {
        role = host.value.role
        dynamic "ssh" {
          for_each = can(host.value.ssh) ? [1] : [] # one loop if there er a value
          content {
            address  = host.value.ssh.address
            user     = host.value.ssh.user
            key_path = host.value.ssh.keyPath
            port     = 22
          }
        }
      }
    }

    mcr {
      channel             = "stable"
      install_url_linux   = "https://get.mirantis.com/"
      repo_url            = "https://repos.mirantis.com"
      version             = var.mcr_version
    }

    # MKE configuration
    mke {
      admin_password = var.admin_password
      admin_username = "admin"
      image_repo     = "docker.io/mirantis"
      version        = var.mke_version
      license_file_path = var.license_file_path != null ? var.license_file_path : ""
      install_flags  = [
      "--default-node-orchestrator=kubernetes",
      "--pod-cidr 172.16.0.0/16",
      "--service-cluster-ip-range=172.17.0.0/16",
      ]
      upgrade_flags  = ["--force-recent-backup", "--force-minimums"]
    } 
  }
}

resource "null_resource" "sleep_after_launchpad_config" {
  depends_on = [launchpad_config.cluster]
  
  provisioner "local-exec" {
    command = "sleep 180"
  }
}
