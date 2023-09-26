module "provision" {
  source = "github.com/wkonitzer/mke-on-equinix-terraform-templates"
  project_id   = var.project_id
  cluster_name = var.cluster_name
  master_count = var.master_count
  worker_count = var.worker_count
  metros       = var.metros
}

module "launchpad" {
  depends_on = [module.provision]
  source        = "./modules/launchpad" 
  cluster_name  = var.cluster_name
  mcr_version   = var.mcr_version
  admin_password  = var.admin_password
  mke_version   = var.mke_version
  license_file_path = var.license_file_path
  provision = module.provision.hosts
}

provider "godaddy" {
  key    = var.godaddy_api_key
  secret = var.godaddy_api_secret
}

provider "mke" {
  endpoint          = "https://${module.launchpad.first_manager_ip}"
  username          = "admin"
  password          = var.admin_password
  unsafe_ssl_client = true
}

resource "mke_clientbundle" "admin" {
  label = "for-terraform"
  depends_on = [module.launchpad]
}

provider "kubernetes" {
  host                   = resource.mke_clientbundle.admin.kube_host
  client_certificate     = resource.mke_clientbundle.admin.client_cert
  client_key             = resource.mke_clientbundle.admin.private_key
  cluster_ca_certificate = resource.mke_clientbundle.admin.ca_cert

  insecure = resource.mke_clientbundle.admin.kube_skiptlsverify
}

provider "helm" {
  kubernetes {
    host                   = resource.mke_clientbundle.admin.kube_host
    client_certificate     = resource.mke_clientbundle.admin.client_cert
    client_key             = resource.mke_clientbundle.admin.private_key
    cluster_ca_certificate = resource.mke_clientbundle.admin.ca_cert
  }
}

provider "kubectl" {
  host                   = resource.mke_clientbundle.admin.kube_host
  client_certificate     = resource.mke_clientbundle.admin.client_cert
  client_key             = resource.mke_clientbundle.admin.private_key
  cluster_ca_certificate = resource.mke_clientbundle.admin.ca_cert
  load_config_file       = false
}

module "metallb" {
  source             = "./modules/metallb_setup"
  depends_on         = [module.launchpad]
  lb_address_range   = module.provision.lb_address_range
}

module "caddy" {
  source = "./modules/caddy"
  depends_on = [module.metallb.metallb_dependencies]
  email = var.email
}

module "gcp_microservices_demo" {
  source     = "./modules/gcp_microservices_demo"
  depends_on = [module.caddy]
}

module "microservice_ingress" {
  source = "./modules/microservice_ingress"
  depends_on  = [module.caddy, module.gcp_microservices_demo]
  namespace = module.gcp_microservices_demo.created_namespace
  domain_name = var.domain_name
  server_name = var.server_name
}