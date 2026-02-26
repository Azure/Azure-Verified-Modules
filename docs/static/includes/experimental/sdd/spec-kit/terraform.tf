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
      source  = "azure/azapi"
      version = "~> 2.4"
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
# Provider: azurerm
# features {} block is mandatory even when no sub-features are customised.
# The azapi + time + random providers require no additional configuration.
# -----------------------------------------------------------------------------
provider "azurerm" {
  features {}

  # Use Azure AD auth for all storage data-plane operations (queue, blob, file,
  # table probes) instead of shared-key / SAS.  Required because the storage
  # account has allowSharedKeyAccess = false, and the provider's Read() function
  # normally queries queue properties via key auth.
  storage_use_azuread = true
}
