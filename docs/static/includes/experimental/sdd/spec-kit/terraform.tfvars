# Global
location    = "westus3"
environment = "prod"
workload    = "legacy"
tags = {
  environment = "prod"
  workload    = "legacy"
}

# Networking
vnet_address_space  = ["10.0.0.0/16"]
subnet_bastion_cidr = "10.0.0.0/26"
subnet_vm_cidr      = "10.0.1.0/24"
subnet_pe_cidr      = "10.0.2.0/24"

# Virtual machine
vm_sku_size          = "Standard_D2s_v3"
vm_admin_username    = "vmadmin"
vm_image_publisher   = "MicrosoftWindowsServer"
vm_image_offer       = "WindowsServer"
vm_image_sku         = "2016-Datacenter"
vm_os_disk_type      = "Standard_LRS"
vm_data_disk_size_gb = 500
vm_data_disk_type    = "Standard_LRS"
vm_computer_name     = "leg-prod-001"
vm_availability_zone = 1

# Key Vault
kv_sku                        = "standard"
vm_admin_password_secret_name = "vm-admin-password"

# Storage
storage_file_share_name     = "share-legacy-prod"
storage_file_share_quota_gb = 100

# Log Analytics
log_analytics_retention_days = 30

# Alert thresholds
alert_disk_free_threshold_pct = 10
alert_vm_metric_window_size   = "PT5M"
alert_disk_query_window       = "PT15M"
alert_kv_metric_window_size   = "PT15M"
