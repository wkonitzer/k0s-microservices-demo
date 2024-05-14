resource "helm_release" "external_dns" {
  create_namespace = true
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  namespace  = "external-dns"

  set {
    name  = "provider.name"
    value = "godaddy"
  }

  set_sensitive {
    name  = "extraArgs[0]"
    value = "--godaddy-api-key=${var.godaddy_api_key}"
  }

  set_sensitive {
    name  = "extraArgs[1]"
    value = "--godaddy-api-secret=${var.godaddy_api_secret}"
  }
}         
