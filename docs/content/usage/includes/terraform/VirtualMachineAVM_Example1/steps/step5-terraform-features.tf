terraform {
  required_version = "~> 1.9"
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.12"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.27"
    }
  }
}

provider "azapi" {
  enable_preflight = true
}

provider "azurerm" {
  features {}
}
