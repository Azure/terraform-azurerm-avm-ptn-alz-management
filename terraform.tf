terraform {
  required_version = "~> 1.8"

  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "2.0.0-beta"
    }
    modtm = {
      source  = "azure/modtm"
      version = "~> 0.3"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}
