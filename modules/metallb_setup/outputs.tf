#output "kubeconfig_file" {
#  description = "Path to the kubeconfig file."
#  value = data.local_file.kubeconfig_path.content
#}

output "metallb_dependencies" {
  value = null_resource.metallb_dependencies
}