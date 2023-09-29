module "os_config" {
  source    = "./modules/os_config" 
  provision = var.provision
}

module "taints" {
  source     = "./modules/taints"
}

module "mke_setup" {
  source     = "./modules/mke_setup"
  admin_username = var.admin_username
  admin_password = var.admin_password
  host = var.host
}

module "longhorn" {
  source             = "./modules/longhorn_setup"
  depends_on         = [module.os_config, module.taints, module.mke_setup]
}

module "auth_proxy" {
  source             = "./modules/auth_proxy"
  depends_on         = [module.longhorn]
  domain_name = var.domain_name 
  server_name = var.server_name
}
