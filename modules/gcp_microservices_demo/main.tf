resource "null_resource" "checkout_and_apply" {
  provisioner "local-exec" {
    command = <<EOT
      git clone https://github.com/GoogleCloudPlatform/microservices-demo.git ${path.root}/microservices-demo
      kubectl --kubeconfig=${path.root}/kubeconfig apply -f ${path.root}/microservices-demo/release/kubernetes-manifests.yaml
    EOT
  }
}
