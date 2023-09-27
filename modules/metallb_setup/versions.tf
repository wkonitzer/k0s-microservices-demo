terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.11.0"
    }   
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.1"
    }              
  }
}
