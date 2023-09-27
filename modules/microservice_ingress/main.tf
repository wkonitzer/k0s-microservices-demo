resource "kubernetes_ingress_v1" "microservice_ingress" {
  metadata {
    name      = var.server_name
    namespace = var.namespace
    annotations = {
      "kubernetes.io/ingress.class" = "caddy"
    }
  }
  spec {
    rule {
      host = "${var.server_name}.${var.domain_name}"
      http {
        path {
          path     = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "frontend"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

resource "null_resource" "wait_for_lb" {
  depends_on = [kubernetes_ingress_v1.microservice_ingress]

  provisioner "local-exec" {
    command = "sleep 30"
  }
}

data "kubernetes_ingress_v1" "microservice" {
  depends_on = [kubernetes_ingress_v1.microservice_ingress, null_resource.wait_for_lb]
  metadata {
    name      = "microservice"
    namespace = var.namespace 
  }
}

resource "godaddy_domain_record" "microservice_lb" {
  depends_on = [null_resource.wait_for_lb, kubernetes_ingress_v1.microservice_ingress, data.kubernetes_ingress_v1.microservice]
  domain = var.domain_name
  record {
    name   = var.server_name
    type   = "A"
    data   = data.kubernetes_ingress_v1.microservice.status.0.load_balancer.0.ingress.0.ip
    ttl    = 600
  }
}