terraform {
  required_providers {
    launchpad = {
      source  = "mirantis/launchpad"
      version = ">= 0.6.3"
    }     
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.1"
    }              
  }
}
