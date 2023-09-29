module "cert-manager" {
  source    = "./modules/cert-manager" 
}

module "postgres" {
  source    = "./modules/postgres-operator" 
}

module "msr_setup" {
  depends_on         = [module.postgres, module.cert-manager]
  source    = "./modules/msr_setup"
  license_file_path = var.license_file_path 
}

module "msr_ingress" {
  source    = "./modules/msr-ingress"
  depends_on         = [module.msr_setup]
  domain_name = var.domain_name 
  server_name = var.server_name
}