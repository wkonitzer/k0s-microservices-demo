locals {
  kubeconfig_path = abspath("${path.root}/kubeconfig")
}

resource "kubernetes_namespace" "msr" {
  metadata {
    name = "msr"
  }
}

resource "null_resource" "install_helm_chart" {
  provisioner "local-exec" {
    command = <<EOT
      export KUBECONFIG=${local.kubeconfig_path}
      helm repo add msrofficial https://registry.mirantis.com/charts/msr/msr
      helm repo update
      helm install msr msrofficial/msr --namespace msr --set-file license=${var.license_file_path}
    EOT
  }
  
  triggers = {
    chart_version = var.chart_version
  }
}