resource "helm_release" "caddy" {
  create_namespace = true
  name       = "mycaddy"
  namespace  = var.namespace
  repository = "https://caddyserver.github.io/ingress/"
  chart      = "caddy-ingress-controller"

  set {
    name  = "ingressController.config.email"
    value = var.email
  }
}