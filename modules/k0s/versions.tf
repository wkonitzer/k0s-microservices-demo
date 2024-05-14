terraform {
  required_providers {  
    local = {
      source  = "hashicorp/local"
      version = ">= 2.3.0"
    } 
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.1"
    }              
  }
}
