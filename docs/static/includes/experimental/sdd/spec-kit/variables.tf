# =============================================================================
# variables.tf — Input variable declarations for My Legacy Workload
#
# Workload : My Legacy Workload (001-my-legacy-workload)
# Variables are grouped by concern to match the section structure in
# terraform.tfvars.  All defaults reflect the single production environment
# targeted by this configuration (westus3 / prod / legacy).
# =============================================================================

# ─── Global ──────────────────────────────────────────────────────────────────

variable "location" {
  type        = string
  default     = "westus3"
  description = "Azure region for all resources in this workload."
}

variable "environment" {
  type        = string
  default     = "prod"
  description = "Deployment environment label used in resource names and tags (e.g. prod, dev, staging)."
}

variable "workload" {
  type        = string
  default     = "legacy"
  description = "Short workload identifier used in resource names and tags."
}

variable "tags" {
  type        = map(string)
  default     = { environment = "prod", workload = "legacy" }
  description = "Base tag map merged with workload/environment/managedBy/region tags for every resource."
}

# ─── Networking ──────────────────────────────────────────────────────────────

variable "vnet_address_space" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
  description = "CIDR address space assigned to the virtual network."
}

variable "subnet_bastion_cidr" {
  type        = string
  default     = "10.0.0.0/26"
  description = "Address prefix for the AzureBastionSubnet.  Must be /26 or larger to satisfy Azure Bastion requirements."
}

variable "subnet_vm_cidr" {
  type        = string
  default     = "10.0.1.0/24"
  description = "Address prefix for the VM subnet.  VMs are deployed here with NAT outbound only — no public IPs."
}

variable "subnet_pe_cidr" {
  type        = string
  default     = "10.0.2.0/24"
  description = "Address prefix for the private-endpoint subnet.  Private endpoints for storage are placed here."
}

# ─── Virtual Machine ─────────────────────────────────────────────────────────

variable "vm_sku_size" {
  type        = string
  default     = "Standard_D2s_v3"
  description = "Azure VM SKU — must provide >= 2 vCPU and >= 8 GB RAM (FR-008)."
}

variable "vm_admin_username" {
  type        = string
  default     = "vmadmin"
  description = "Local administrator username for the Windows VM."

  validation {
    condition     = length(var.vm_admin_username) > 0
    error_message = "vm_admin_username must not be empty."
  }
}

variable "vm_image_publisher" {
  type        = string
  default     = "MicrosoftWindowsServer"
  description = "Publisher of the VM source image."
}

variable "vm_image_offer" {
  type        = string
  default     = "WindowsServer"
  description = "Offer of the VM source image."
}

variable "vm_image_sku" {
  type        = string
  default     = "2016-Datacenter"
  description = "SKU of the VM source image (FR-007: Windows Server 2016)."
}

variable "vm_os_disk_type" {
  type        = string
  default     = "Standard_LRS"
  description = "Storage type for the OS disk (Standard_LRS = Standard HDD, FR-008)."
}

variable "vm_data_disk_size_gb" {
  type        = number
  default     = 500
  description = "Size of the data disk in GB (FR-009: 500 GB)."

  validation {
    condition     = var.vm_data_disk_size_gb >= 1
    error_message = "vm_data_disk_size_gb must be at least 1 GB."
  }
}

variable "vm_data_disk_type" {
  type        = string
  default     = "Standard_LRS"
  description = "Storage type for the data disk (Standard_LRS = Standard HDD, FR-009)."
}

variable "vm_computer_name" {
  type        = string
  default     = "leg-prod-001"
  description = "Windows computer (NetBIOS) name for the VM.  Must be <= 15 characters (FR-013).  The Azure resource name is controlled by local.vm_name."

  # CHK032: computer name must fit in NetBIOS 15-char limit and follow DNS rules
  validation {
    condition     = length(var.vm_computer_name) <= 15 && can(regex("^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$", var.vm_computer_name))
    error_message = "vm_computer_name must be 15 characters or fewer, contain only alphanumeric characters and hyphens, and must not start or end with a hyphen (FR-013, CHK032)."
  }
}

variable "vm_availability_zone" {
  type        = number
  default     = 1
  description = "Availability zone number (1, 2, or 3) for the VM and NAT gateway public IP (FR-014)."

  # CHK033: zone 0 and -1 are explicitly prohibited
  validation {
    condition     = contains([1, 2, 3], var.vm_availability_zone)
    error_message = "vm_availability_zone must be 1, 2, or 3. Values 0 and -1 are explicitly prohibited (FR-015, CHK033)."
  }
}

# ─── Key Vault ───────────────────────────────────────────────────────────────

variable "kv_sku" {
  type        = string
  default     = "standard"
  description = "Key Vault SKU tier (standard or premium)."
}

variable "vm_admin_password_secret_name" {
  type        = string
  default     = "vm-admin-password"
  description = "Name of the Key Vault secret that holds the VM administrator password (FR-018)."
}

# ─── Storage ─────────────────────────────────────────────────────────────────

variable "storage_file_share_name" {
  type        = string
  default     = "share-legacy-prod"
  description = "Name of the Azure Files file share."
}

variable "storage_file_share_quota_gb" {
  type        = number
  default     = 100
  description = "Quota of the file share in GB."
}

# ─── Log Analytics ───────────────────────────────────────────────────────────

variable "log_analytics_retention_days" {
  type        = number
  default     = 30
  description = "Number of days to retain logs in the Log Analytics workspace (minimum 30 for compliance)."
}

# ─── Alert Thresholds ────────────────────────────────────────────────────────

variable "alert_disk_free_threshold_pct" {
  type        = number
  default     = 10
  description = "Disk available percentage below which the disk-full alert fires (FR-028)."
}

variable "alert_vm_metric_window_size" {
  type        = string
  default     = "PT5M"
  description = "ISO 8601 evaluation window for the VM availability metric alert (FR-027)."
}

variable "alert_disk_query_window" {
  type        = string
  default     = "PT15M"
  description = "ISO 8601 evaluation frequency and window for the disk-space scheduled query alert (FR-028)."
}

variable "alert_kv_metric_window_size" {
  type        = string
  default     = "PT15M"
  description = "ISO 8601 evaluation window for the Key Vault access-failure metric alert (FR-029)."
}
