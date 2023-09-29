resource "kubectl_manifest" "secret" {
  yaml_body = <<-YAML
apiVersion: v1
kind: Secret
metadata:
  name: nginx-basic-auth
  namespace: longhorn-system
type: Opaque
data:
  # Replace this with the base64 encoded content of your .htpasswd file
  # htpasswd -c .htpasswd admin
  # cat .htpasswd | base64
  .htpasswd: YWRtaW46JGFwcjEkLnlMaEgvbFokRUEzbWVCZTlNVjgwNHkwNUZRLkN0MQo=
  YAML
}

resource "kubectl_manifest" "configmap" {
  yaml_body = <<-YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-config
  namespace: longhorn-system
data:
  nginx.conf: |
    user  nginx;
    worker_processes  1;
    error_log  /var/log/nginx/error.log warn;
    pid        /var/run/nginx.pid;

    events {
      worker_connections  1024;
    }

    http {
      server {
          listen 80;

          location / {
              auth_basic "Restricted Area";
              auth_basic_user_file /etc/nginx/conf.d/.htpasswd;

              proxy_pass http://longhorn-frontend.longhorn-system.svc.cluster.local:80;
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          }
      }
    }
  YAML
}      

resource "kubectl_manifest" "deployment" {
  yaml_body = <<-YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-auth-deployment
  namespace: longhorn-system
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-auth
  template:
    metadata:
      labels:
        app: nginx-auth
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80        
        volumeMounts:
        - name: nginx-config-volume
          mountPath: /etc/nginx/nginx.conf
          subPath: nginx.conf
        - name: nginx-basic-auth
          mountPath: /etc/nginx/conf.d/.htpasswd
          subPath: .htpasswd
      volumes:
      - name: nginx-config-volume
        configMap:
          name: nginx-config
      - name: nginx-basic-auth
        secret:
          secretName: nginx-basic-auth
  YAML          
}

resource "kubectl_manifest" "service" {
  yaml_body = <<-YAML
apiVersion: v1
kind: Service
metadata:
  name: nginx-auth-service
  namespace: longhorn-system
spec:
  selector:
    app: nginx-auth
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  YAML
}      

resource "kubectl_manifest" "ingress" {
  yaml_body = <<-YAML
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: longhorn-ingress
  namespace: longhorn-system
  annotations:
    kubernetes.io/ingress.class: caddy
spec:
  rules:
  - host: "${var.server_name}.${var.domain_name}"
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: nginx-auth-service
            port:
              number: 80
  YAML
} 
