terraform {
  required_providers {  
    godaddy = {
      source  = "n3integration/godaddy"
      version =">= 1.9.1"
    }
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
