# =============================================================================
# terraform.tf — Provider and Terraform version requirements
#
# Workload : My Legacy Workload (001-my-legacy-workload)
# Region   : West US 3 (westus3)
# This file declares the minimum Terraform version and every provider required
# by this configuration.  AVM modules that use azapi or time internally will
# inherit these constraints automatically.
# =============================================================================

terraform {
  required_version = ">= 1.10, < 2.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.37"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.12"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9.0, < 1.0.0"
    }
  }
}

# -----------------------------------------------------------------------------
# Providers used by the solution.
# -----------------------------------------------------------------------------
provider "azapi" {
  enable_preflight = true
}

provider "azurerm" {
  features {}
  storage_use_azuread = true
}
