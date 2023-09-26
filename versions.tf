terraform {
  required_providers {
    mke = {
      source  = "Mirantis/mke"
    }
    godaddy = {
      source  = "n3integration/godaddy"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }    
  }
}
