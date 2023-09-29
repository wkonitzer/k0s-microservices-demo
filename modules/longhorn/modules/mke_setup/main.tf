resource "null_resource" "get_auth_token" {
  provisioner "local-exec" {
    command = <<EOT
    curl --silent --insecure --data '{"username":"${var.admin_username}","password":"${var.admin_password}"}' https://${var.host}/auth/login | jq --raw-output .auth_token > auth_token.txt
    EOT
  }
  triggers = {
    always_run = timestamp()
  }
}

resource "null_resource" "set_grant" {
  depends_on = [null_resource.get_auth_token]
  provisioner "local-exec" {
    command = <<EOT
    AUTHTOKEN=$(cat auth_token.txt)
    curl --silent --insecure -X PUT https://${var.host}/collectionGrants/authenticated/swarm/scheduler -H "accept: application/json" -H "Authorization: Bearer $AUTHTOKEN"
    EOT
  }  
}

resource "null_resource" "get_config" {
  depends_on = [null_resource.set_grant]
  provisioner "local-exec" {
    command = <<EOT
    AUTHTOKEN=$(cat auth_token.txt)
    curl --silent --insecure -X GET "https://${var.host}/api/ucp/config-toml" -H "accept: application/toml" -H "Authorization: Bearer $AUTHTOKEN" > mke-config.toml
    EOT
  }
}

resource "null_resource" "modify_config" {
  depends_on = [null_resource.get_config]
  provisioner "local-exec" {
    command = <<EOT
    if ! grep -q "priv_attributes_allowed_for_service_accounts = \\[\"hostbindmounts\", \"privileged\", \"kernelCapabilities\", \"hostPID\"\\]" mke-config.toml; then
      awk '/kubelet_data_root = "\/var\/lib\/kubelet"/{print "  priv_attributes_allowed_for_user_accounts = [\"hostbindmounts\", \"privileged\"]\n  priv_attributes_user_accounts = [\"longhorn-system:longhorn-service-account,postgres-system:postgres-pod\"]\n  priv_attributes_allowed_for_service_accounts = [\"hostbindmounts\", \"privileged\", \"kernelCapabilities\", \"hostPID\"]\n  priv_attributes_service_accounts = [\"longhorn-system:longhorn-service-account,postgres-system:postgres-pod\"]"}1' mke-config.toml > temp.toml && mv temp.toml mke-config.toml
    fi
    EOT
  }
}

resource "null_resource" "apply_config" {
  depends_on = [null_resource.modify_config]
  provisioner "local-exec" {
    command = <<EOT
    AUTHTOKEN=$(cat auth_token.txt)
    curl --silent --insecure -X PUT -H "accept: application/toml" -H "Authorization: Bearer $AUTHTOKEN" --upload-file 'mke-config.toml' https://${var.host}/api/ucp/config-toml
    EOT
  }
}

resource "null_resource" "wait_for_config" {
  depends_on = [null_resource.apply_config]

  provisioner "local-exec" {
    command = "sleep 30"
  }
}

resource "null_resource" "apply_config_again" {
  depends_on = [null_resource.modify_config]
  provisioner "local-exec" {
    command = <<EOT
    AUTHTOKEN=$(cat auth_token.txt)
    curl --silent --insecure -X PUT -H "accept: application/toml" -H "Authorization: Bearer $AUTHTOKEN" --upload-file 'mke-config.toml' https://${var.host}/api/ucp/config-toml
    EOT
  }
}
