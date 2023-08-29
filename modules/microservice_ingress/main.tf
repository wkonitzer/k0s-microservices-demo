terraform {
  required_providers {
    godaddy = {
      source  = "n3integration/godaddy"
    }
  }
}

resource "kubernetes_manifest" "microservice_ingress" {
  count = fileexists("${path.root}/kubeconfig") && fileexists("${path.module}/../metallb_setup/.metallb_setup_complete") ? 1 : 0
  manifest = {
    apiVersion = "networking.k8s.io/v1"
    kind       = "Ingress"
    metadata   = {
      name      = var.server_name
      namespace = "default"
      annotations = {
        "kubernetes.io/ingress.class" = "caddy"
      }
    }
    spec = {
      rules = [{
        host = "${var.server_name}.${var.domain_name}"
        http = {
          paths = [{
            path     = "/"
            pathType = "Prefix"
            backend = {
              service = {
                name = "frontend"
                port = {
                  number = 80
                }
              }
            }
          }]
        }
      }]
    }
  }
}

resource "null_resource" "wait_for_lb" {
  depends_on = [kubernetes_manifest.microservice_ingress]

  provisioner "local-exec" {
    command = "sleep 30"
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

resource "null_resource" "extract_lb_ip" {
  depends_on = [null_resource.wait_for_lb]

  provisioner "local-exec" {
    command = <<EOT
      kubectl --kubeconfig=${path.root}/kubeconfig get ingress microservice -o jsonpath='{.status.loadBalancer.ingress[0].ip}' > ${path.module}/.lb_ip.txt
    EOT
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

data "local_file" "lb_ip" {
  depends_on = [null_resource.extract_lb_ip]
  filename = "${path.module}/.lb_ip.txt"
}

resource "godaddy_domain_record" "microservice_lb" {
  depends_on = [null_resource.wait_for_lb]
  domain = var.domain_name
  record {
    name   = var.server_name
    type   = "A"
    data   = data.local_file.lb_ip.content
    ttl    = 600
  }
}