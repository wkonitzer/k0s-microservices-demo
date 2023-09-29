terraform {
  required_providers {  
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.23.0"
    }   
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.1"
    }              
  }
}
