resource "helm_release" "cert-manager" {
  create_namespace = true
  name       = "cert-manager"
  namespace  = "cert-manager-system"
  chart      = "cert-manager"
  repository = "https://charts.jetstack.io"
  version    = var.chart_version

  set {
    name  = "installCRDs"
    value = "true"
  }

  provisioner "local-exec" {
    command = "sleep 30"
  }  
}
