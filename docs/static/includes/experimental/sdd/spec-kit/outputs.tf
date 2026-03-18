# =============================================================================
# outputs.tf — Output declarations for My Legacy Workload
#
# Outputs expose the resource IDs and names that downstream consumers
# (pipelines, runbooks, or child modules) need.  Credential values are never
# output — the VM password lives only in random_password state and in Key
# Vault; it is never surfaced here.
# =============================================================================

# ─── Resource Group ──────────────────────────────────────────────────────────

output "resource_group_id" {
  description = "Resource ID of the workload resource group."
  value       = module.resource_group.resource_id
}

# ─── Networking ──────────────────────────────────────────────────────────────

output "virtual_network_id" {
  description = "Resource ID of the virtual network."
  value       = module.virtual_network.resource_id
}

output "subnet_vm_id" {
  description = "Resource ID of the VM subnet."
  value       = module.virtual_network.subnets["vm_subnet"].resource_id
}

output "subnet_bastion_id" {
  description = "Resource ID of the Azure Bastion subnet."
  value       = module.virtual_network.subnets["bastion_subnet"].resource_id
}

output "subnet_pe_id" {
  description = "Resource ID of the private-endpoint subnet."
  value       = module.virtual_network.subnets["pe_subnet"].resource_id
}

# ─── Key Vault ───────────────────────────────────────────────────────────────

output "key_vault_id" {
  description = "Resource ID of the Key Vault (not a credential — safe to share downstream)."
  value       = module.key_vault.resource_id
  sensitive   = false
}

output "key_vault_name" {
  description = "Name of the Key Vault."
  value       = local.key_vault_name
}

# ─── Storage ─────────────────────────────────────────────────────────────────

output "storage_account_id" {
  description = "Resource ID of the storage account (not a credential — safe to share downstream)."
  value       = module.storage_account.resource_id
  sensitive   = false
}

output "storage_account_name" {
  description = "Name of the storage account."
  value       = local.storage_account_name
}

# ─── Virtual Machine ─────────────────────────────────────────────────────────

output "vm_id" {
  description = "Resource ID of the virtual machine."
  value       = module.virtual_machine.resource_id
}

output "vm_name" {
  description = "Azure resource name of the virtual machine."
  value       = local.vm_name
}

# ─── Observability ───────────────────────────────────────────────────────────

output "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics workspace."
  value       = module.log_analytics_workspace.resource_id
}

# ─── Bastion ─────────────────────────────────────────────────────────────────

output "bastion_name" {
  description = "Azure resource name of the Bastion host."
  value       = local.bastion_name
}
