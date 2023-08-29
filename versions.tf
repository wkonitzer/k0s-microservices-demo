terraform {
  required_providers {
    equinix = {
      source  = "equinix/equinix"
      version = ">= 1.15.0"
    }
    godaddy = {
      source  = "n3integration/godaddy"
    }
  }
}