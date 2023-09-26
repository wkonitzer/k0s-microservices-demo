output "created_namespace" {
  value = helm_release.onlineboutique.namespace
  description = "The namespace created for the helm release"
}