terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

resource "helm_release" "metallb" {
  create_namespace = true
  name       = "metallb"
  namespace  = "metallb-system"
  chart      = "metallb"
  repository = "https://metallb.github.io/metallb"
  version    = var.chart_version

  set {
    name  = "speaker.memberlist.mlBindPort"
    value = "17946"
  }

  provisioner "local-exec" {
    command = "sleep 120"
  }
}

resource "local_file" "setup_complete_flag" {
  depends_on = [helm_release.metallb]
  filename = "${path.module}/.metallb_setup_complete"
  content  = "This file indicates that metallb has installed"

  provisioner "local-exec" {
    when    = destroy
    command = "rm -f ${self.filename}"
  }
}

resource "kubernetes_manifest" "ip_address_pool" {
  provider = kubernetes
  depends_on = [local_file.setup_complete_flag]
  count = fileexists("${path.root}/kubeconfig") && fileexists("${path.module}/.metallb_setup_complete") ? 1 : 0

  manifest = {
    apiVersion = "metallb.io/v1beta1"
    kind       = "IPAddressPool"
    metadata = {
      name      = "first-pool"
      namespace = "metallb-system"
    }
    spec = {
      addresses = [var.lb_address_range]
    }
  }
}

resource "kubernetes_manifest" "l2_advertisement" {
  provider = kubernetes
  depends_on = [local_file.setup_complete_flag]
  count = fileexists("${path.root}/kubeconfig") && fileexists("${path.module}/.metallb_setup_complete") ? 1 : 0
  
  manifest = {
    apiVersion = "metallb.io/v1beta1"
    kind       = "L2Advertisement"
    metadata = {
      name      = "example"
      namespace = "metallb-system"
    }
  }
}