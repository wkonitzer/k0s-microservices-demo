resource "kubectl_manifest" "namesoace" {
  yaml_body = <<-YAML
apiVersion: v1
kind: Namespace
metadata:
  name: external-dns
  YAML
}    

resource "kubectl_manifest" "serviceaccount" {
  yaml_body = <<-YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  name: external-dns
  namespace: external-dns
  YAML
}  

resource "kubectl_manifest" "clusterrole" {
  yaml_body = <<-YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: external-dns
rules:
- apiGroups: [""]
  resources: ["services"]
  verbs: ["get","watch","list"]
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get","watch","list"]
- apiGroups: ["extensions","networking.k8s.io"]
  resources: ["ingresses"]
  verbs: ["get","watch","list"]
- apiGroups: [""]
  resources: ["nodes"]
  verbs: ["list","watch"]
- apiGroups: [""]
  resources: ["endpoints"]
  verbs: ["get","watch","list"]
  YAML
}

resource "kubectl_manifest" "clusterrolebinding" {
  yaml_body = <<-YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: external-dns-viewer
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: external-dns
subjects:
- kind: ServiceAccount
  name: external-dns
  namespace: external-dns
  YAML
}    

resource "kubectl_manifest" "deployment" {
  yaml_body = <<-YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: external-dns
  namespace: external-dns
spec:
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: external-dns
  template:
    metadata:
      labels:
        app: external-dns
    spec:
      serviceAccountName: external-dns
      containers:
      - name: external-dns
        image: registry.k8s.io/external-dns/external-dns:v0.13.5
        args:
        - --source=service 
        - --source=ingress 
        - --domain-filter=${var.domain_name}
        - --provider=godaddy
        - --txt-prefix=external-dns 
        - --txt-owner-id=owner-id 
        - --godaddy-api-key=${var.godaddy_api_key}
        - --godaddy-api-secret=${var.godaddy_api_secret}
  YAML
}          
