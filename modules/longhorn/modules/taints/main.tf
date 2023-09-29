data "kubernetes_nodes" "all_nodes" {}

locals {
  master_nodes = [for node in data.kubernetes_nodes.all_nodes.nodes : node.metadata[0].name if length([for taint in node.spec[0].taints : taint.key if taint.key == "com.docker.ucp.manager"]) > 0]

  yaml_body = join("\n---\n", [for node in local.master_nodes : <<-EOT
    apiVersion: v1
    kind: Node
    metadata:
      name: ${node}
    spec:
      taints:
      - key: "node-role.kubernetes.io/master"
        effect: "NoSchedule"
  EOT
  ])
}

resource "kubectl_manifest" "apply_taints" {
  
  yaml_body = local.yaml_body
  
  lifecycle {
    ignore_changes = [yaml_body]
  }
}
