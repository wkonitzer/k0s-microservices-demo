resource "kubernetes_namespace" "caddy" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "caddy" {
  depends_on = [kubernetes_namespace.caddy]

  name       = "mycaddy"
  namespace  = var.namespace
  repository = "https://caddyserver.github.io/ingress/"
  chart      = "caddy-ingress-controller"

  set {
    name  = "ingressController.config.email"
    value = var.email
  }
}