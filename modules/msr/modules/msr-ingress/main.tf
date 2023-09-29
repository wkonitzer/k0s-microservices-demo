resource "kubernetes_ingress_v1" "msr_ingress" {
  metadata {
    name      = "msr-ingress"
    namespace = "msr"
    annotations = {
      "kubernetes.io/ingress.class" = "caddy"
      "caddy.ingress.kubernetes.io/backend-protocol" = "HTTPS"
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
              name = "msr"
              port {
                number = 443
              }
            }
          }
        }
      }
    }
  }
}