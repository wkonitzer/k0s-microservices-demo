resource "helm_release" "onlineboutique" {
  name       = "onlineboutique"
  create_namespace = true
  namespace = var.namespace
  chart      = "oci://us-docker.pkg.dev/online-boutique-ci/charts/onlineboutique"

  lifecycle {
    create_before_destroy = true
  }
}
