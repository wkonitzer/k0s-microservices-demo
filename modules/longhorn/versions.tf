terraform {
  required_providers {  
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.11.0"
    } 
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.23.0"
    }
    godaddy = {
      source  = "n3integration/godaddy"
      version =">= 1.9.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }                        
  }
}
