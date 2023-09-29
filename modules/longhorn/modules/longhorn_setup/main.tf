resource "helm_release" "longhorn" {
  create_namespace = true
  name       = "longhorn"
  namespace  = "longhorn-system"
  chart      = "longhorn"
  repository = "https://charts.longhorn.io"
  version    = var.chart_version

  set {
    name  = "csi.kubeletRootDir"
    value = "/var/lib/kubelet"
  }
}
