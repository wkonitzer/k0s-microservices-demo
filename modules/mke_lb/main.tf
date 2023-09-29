locals {
  ucp_443_servers = join("\n", [for host in var.provision : "server ${host.ssh.address}:443 max_fails=2 fail_timeout=30s;" if host.role == "manager"])
  ucp_6443_servers = join("\n", [for host in var.provision : "server ${host.ssh.address}:6443 max_fails=2 fail_timeout=30s;" if host.role == "manager"])
}

resource "kubectl_manifest" "namespace" {
  yaml_body = <<-YAML
apiVersion: v1
kind: Namespace
metadata:
  name: mke-lb
  YAML
}

resource "kubectl_manifest" "configmap" {
  yaml_body = <<-YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-config
  namespace: mke-lb
data:
  nginx.conf: |
    user  nginx;
    worker_processes  1;
    error_log  /var/log/nginx/error.log warn;
    pid        /var/run/nginx.pid;
    events {
      worker_connections  1024;
    }
    stream {
      upstream ucp_443 {
        ${indent(8, chomp(local.ucp_443_servers))}
      }
      server {
        listen 443;
        proxy_pass ucp_443;
      }

      upstream ucp_6443 {
        ${indent(8, chomp(local.ucp_6443_servers))}
      }
      server {
        listen 6443;
        proxy_pass ucp_6443;
      }      
    }
  YAML
}
     

resource "kubectl_manifest" "deployment" {
  yaml_body = <<-YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-lb
  namespace: mke-lb
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx-lb
  template:
    metadata:
      labels:
        app: nginx-lb
    spec:
      containers:
      - name: nginx
        image: nginx:stable
        ports:
        - containerPort: 443
        - containerPort: 6443
        volumeMounts:
        - name: nginx-config-volume
          mountPath: /etc/nginx/nginx.conf
          subPath: nginx.conf
      volumes:
      - name: nginx-config-volume
        configMap:
          name: nginx-config
  YAML
}  

resource "kubectl_manifest" "service" {
  yaml_body = <<-YAML
apiVersion: v1
kind: Service
metadata:
  name: nginx-lb-service
  namespace: mke-lb 
spec:
  selector:
    app: nginx-lb
  ports:
    - name: https
      protocol: TCP
      port: 443
      targetPort: 443
    - name: mke  
      protocol: TCP
      port: 6443
      targetPort: 6443      
  type: LoadBalancer
YAML          
}

resource "kubernetes_ingress_v1" "mke_ingress" {
  metadata {
    name      = "mke-ingress"
    namespace = "mke-lb"
    annotations = {
      "kubernetes.io/ingress.class" = "caddy"
      "caddy.ingress.kubernetes.io/backend-protocol" = "HTTPS"
    }
  }
  spec {
    rule {
      host = "${var.server_name}.${var.domain_name}"
      http {
        path {
          path     = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "nginx-lb-service"
              port {
                number = 443
              }
            }
          }
        }
      }
    }
  }
}
