resource "helm_release" "postgres" {
  create_namespace = true
  name       = "postgres-operator"
  namespace  = "postgres-system"
  chart      = "postgres-operator"
  repository = "https://opensource.zalando.com/postgres-operator/charts/postgres-operator"
  version    = var.chart_version

  set {
    name  = "configKubernetes.spilo_runasuser"
    value = "101"
  }
  set {
    name  = "configKubernetes.spilo_runasgroup"
    value = "103"
  }
  set {
    name  = "configKubernetes.spilo_fsgroup"
    value = "103"
  }  

  provisioner "local-exec" {
    command = "sleep 30"
  }    
}