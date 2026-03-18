# =============================================================================
# main.tf — My Legacy Workload
#
# Provisions a single-VM Windows Server 2016 workload in West US 3 with:
#   - Isolated network (VNet, 3 subnets, 3 NSGs, NAT gateway, Azure Bastion)
#   - Key Vault (RBAC, no public access) storing the VM admin password
#   - Windows VM (no public IP, write-only password via Terraform 1.10+)
#   - Storage account (private endpoint via Azure Files, TLS 1.2)
#   - Log Analytics workspace receiving all diagnostic logs/metrics
#   - Three Azure Monitor alert rules (VM stopped, disk full, KV failures)
#
# All AVM modules use enable_telemetry = false per project policy.
# Contracts in specs/001-my-legacy-workload/contracts/ are authoritative for
# module versions and argument shapes.
# =============================================================================

# ─── Locals ──────────────────────────────────────────────────────────────────

locals {
  # CAF resource names — static (workload + env + region + instance suffix)
  resource_group_name   = "rg-${var.workload}-${var.environment}-westus3-001"
  vnet_name             = "vnet-${var.workload}-${var.environment}-westus3-001"
  nsg_vm_name           = "nsg-${var.workload}-vm-${var.environment}-westus3-001"
  nsg_bastion_name      = "nsg-${var.workload}-bastion-${var.environment}-westus3-001"
  nsg_pe_name           = "nsg-${var.workload}-pe-${var.environment}-westus3-001"
  nat_gateway_name      = "ng-${var.workload}-${var.environment}-westus3-001"
  nat_gw_pip_name       = "pip-ng-${var.workload}-${var.environment}-westus3-001"
  bastion_name          = "bas-${var.workload}-${var.environment}-westus3-001"
  vm_name               = "vm-${var.workload}-${var.environment}-westus3-001"
  vm_nic_name           = "nic-${var.workload}-${var.environment}-westus3-001"
  vm_os_disk_name       = "osdisk-${var.workload}-${var.environment}-westus3-001"
  vm_data_disk_name     = "datadisk-${var.workload}-${var.environment}-westus3-001"
  log_analytics_name    = "law-${var.workload}-${var.environment}-westus3-001"
  private_dns_zone_name = "privatelink.file.core.windows.net"
  pe_storage_name       = "pep-${var.workload}-file-${var.environment}-westus3-001"

  # Alert names (no region suffix — alerts scope to resource, not region)
  alert_vm_stopped_name  = "alert-${var.workload}-vm-stopped-${var.environment}"
  alert_disk_full_name   = "alert-${var.workload}-disk-full-${var.environment}"
  alert_kv_failures_name = "alert-${var.workload}-kv-failures-${var.environment}"

  # Globally-unique names (6-char random suffix appended)
  # Key Vault: region token OMITTED to stay within the 24-character KV name limit
  key_vault_name       = "kv-${var.workload}-${var.environment}-${random_string.unique_suffix.result}"
  storage_account_name = "st${var.workload}${var.environment}${random_string.unique_suffix.result}"

  # Common tag map: base tags merged with mandatory workload/env/managedBy/region labels
  common_tags = merge(var.tags, {
    workload    = var.workload
    environment = var.environment
    managedBy   = "Terraform"
    region      = var.location
  })
}

# ─── Data Sources ─────────────────────────────────────────────────────────────

# Required to obtain tenant_id for Key Vault RBAC authorization
data "azurerm_client_config" "current" {}

# ─── Random Resources ────────────────────────────────────────────────────────

# 6-char lowercase alphanumeric suffix to make storage and KV names globally unique
resource "random_string" "unique_suffix" {
  length  = 6
  special = false
  upper   = false
}

# VM local admin password — 20 chars with mixed complexity.
# IMPORTANT: random_password.result IS stored in Terraform state (unavoidable
# for generated values).  The value is ALSO written to Key Vault via the KV
# module secrets_value argument.  The VM resource itself uses a write-only
# argument (Terraform 1.10+) so the password does NOT appear in
# azurerm_windows_virtual_machine state.  See SC-003.
resource "random_password" "vm_admin_password" {
  length           = 20
  special          = true
  override_special = "!@#$%^&*()"
  min_lower        = 2
  min_upper        = 2
  min_numeric      = 2
  min_special      = 2
}

# ─── Foundation ──────────────────────────────────────────────────────────────

# Single production resource group — all workload resources land here
module "resource_group" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.2.2"

  name             = local.resource_group_name
  location         = var.location
  tags             = local.common_tags
  enable_telemetry = false
}

# Log Analytics workspace — MUST be created first; all diagnostic settings
# reference module.log_analytics_workspace.resource_id.
module "log_analytics_workspace" {
  source  = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version = "0.5.1"

  name                = local.log_analytics_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name

  log_analytics_workspace_sku               = "PerGB2018"
  log_analytics_workspace_retention_in_days = var.log_analytics_retention_days

  tags             = local.common_tags
  enable_telemetry = false

  depends_on = [module.resource_group]
}

# ─── Networking (US1) ────────────────────────────────────────────────────────

# NSG for VM subnet — permits RDP only from Azure Bastion subnet CIDR (FR-003)
module "nsg_vm" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.5.1"

  name                = local.nsg_vm_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name

  security_rules = {
    # Allow RDP only from Bastion subnet — no direct RDP from internet
    allow_rdp_from_bastion = {
      name                       = "Allow-RDP-From-BastionSubnet"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = var.subnet_bastion_cidr
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "3389"
    }
    deny_all_inbound = {
      name                       = "Deny-All-Inbound"
      priority                   = 4096
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "*"
    }
  }

  diagnostic_settings = {
    to_law = {
      name                  = "diag-to-law"
      workspace_resource_id = module.log_analytics_workspace.resource_id
    }
  }

  tags             = local.common_tags
  enable_telemetry = false
}

# NSG for Azure Bastion subnet — minimum required rules for Bastion Standard SKU
# See: https://learn.microsoft.com/azure/bastion/bastion-nsg
module "nsg_bastion" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.5.1"

  name                = local.nsg_bastion_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name

  security_rules = {
    # Inbound: HTTPS from Internet (portal connectivity)
    allow_https_inbound = {
      name                       = "Allow-HTTPS-Internet-Inbound"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "Internet"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "443"
    }
    # Inbound: Azure Gateway Manager control plane traffic
    allow_gateway_manager = {
      name                       = "Allow-GatewayManager-Inbound"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "GatewayManager"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "443"
    }
    # Inbound: Azure Load Balancer health probe
    allow_azure_lb = {
      name                       = "Allow-AzureLoadBalancer-Inbound"
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "AzureLoadBalancer"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "443"
    }
    # Inbound: Bastion host-to-host communication (data plane)
    allow_bastion_host_comm = {
      name                       = "Allow-BastionHostComm-Inbound"
      priority                   = 130
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_address_prefix      = "VirtualNetwork"
      source_port_range          = "*"
      destination_address_prefix = "VirtualNetwork"
      destination_port_ranges    = toset(["8080", "5701"])
    }
    deny_all_inbound = {
      name                       = "Deny-All-Inbound"
      priority                   = 4096
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "*"
    }
    # Outbound: SSH/RDP sessions to target VMs in the VNet
    allow_ssh_rdp_outbound = {
      name                       = "Allow-SSH-RDP-Outbound"
      priority                   = 100
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "VirtualNetwork"
      destination_port_ranges    = toset(["22", "3389"])
    }
    # Outbound: Azure Cloud endpoints (telemetry, diagnostics)
    allow_azure_cloud_outbound = {
      name                       = "Allow-AzureCloud-Outbound"
      priority                   = 110
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "AzureCloud"
      destination_port_range     = "443"
    }
    # Outbound: Bastion host-to-host communication (data plane)
    allow_bastion_comm_outbound = {
      name                       = "Allow-BastionComm-Outbound"
      priority                   = 120
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_address_prefix      = "VirtualNetwork"
      source_port_range          = "*"
      destination_address_prefix = "VirtualNetwork"
      destination_port_ranges    = toset(["8080", "5701"])
    }
    # Outbound: Session info retrieval (required by Bastion control plane)
    allow_get_session_info_outbound = {
      name                       = "Allow-GetSessionInfo-Outbound"
      priority                   = 130
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "Internet"
      destination_port_ranges    = toset(["80", "443"])
    }
  }

  diagnostic_settings = {
    to_law = {
      name                  = "diag-to-law"
      workspace_resource_id = module.log_analytics_workspace.resource_id
    }
  }

  tags             = local.common_tags
  enable_telemetry = false
}

# NSG for private-endpoint subnet — allows HTTPS from VNet only
module "nsg_pe" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.5.1"

  name                = local.nsg_pe_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name

  security_rules = {
    allow_https_from_vnet = {
      name                       = "Allow-HTTPS-From-VNet"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "VirtualNetwork"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "443"
    }
    deny_all_inbound = {
      name                       = "Deny-All-Inbound"
      priority                   = 4096
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "*"
    }
  }

  diagnostic_settings = {
    to_law = {
      name                  = "diag-to-law"
      workspace_resource_id = module.log_analytics_workspace.resource_id
    }
  }

  tags             = local.common_tags
  enable_telemetry = false
}

# NAT gateway — provides controlled outbound internet access for the VM subnet.
# The VM subnet has no public IP route other than this gateway (FR-011, FR-016).
# StandardV2 SKU required for zone-redundant public IP behaviour.
module "nat_gateway" {
  source  = "Azure/avm-res-network-natgateway/azurerm"
  version = "0.3.2"

  name      = local.nat_gateway_name
  location  = module.resource_group.location
  parent_id = module.resource_group.resource_id

  sku_name = "StandardV2"

  # Allocate a static Standard public IP for outbound SNAT
  public_ips = {
    nat_gw_pip = {
      name = local.nat_gw_pip_name
    }
  }

  # StandardV2 SKU requires all 3 zones (module precondition enforces this)
  public_ip_configuration = {
    nat_gw_pip = {
      allocation_method       = "Static"
      sku                     = "StandardV2"
      idle_timeout_in_minutes = 4
      zones                   = ["1", "2", "3"]
    }
  }

  # NOTE: Diagnostic settings are NOT applied to the NAT gateway — the Azure
  # Insights API for Microsoft.Network/natGateways diagnostic sub-resources does
  # not respond in westus3, causing a perpetual timeout.  NAT gateway byte/packet
  # metrics remain viewable in Azure Monitor without an explicit diagnostic setting.

  tags             = local.common_tags
  enable_telemetry = false
}

# Virtual network — three subnets, each bound to its own NSG.
# NOTE: module version 0.17.1 (contracts/virtual-network.md is authoritative).
# pe_subnet: private_endpoint_network_policies = "Enabled" is required for
# private endpoint policies to function correctly in this subnet.
module "virtual_network" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.17.1"

  name          = local.vnet_name
  location      = module.resource_group.location
  parent_id     = module.resource_group.resource_id
  address_space = var.vnet_address_space

  subnets = {
    # AzureBastionSubnet: name must be exactly "AzureBastionSubnet" (Azure requirement)
    bastion_subnet = {
      name             = "AzureBastionSubnet"
      address_prefixes = [var.subnet_bastion_cidr]
      network_security_group = {
        id = module.nsg_bastion.resource_id
      }
    }
    # VM subnet: outbound via NAT gateway only (no default outbound access)
    vm_subnet = {
      name             = "snet-${var.workload}-vm-${var.environment}-westus3-001"
      address_prefixes = [var.subnet_vm_cidr]
      network_security_group = {
        id = module.nsg_vm.resource_id
      }
      nat_gateway = {
        id = module.nat_gateway.resource_id
      }
      default_outbound_access_enabled = false
    }
    # Private-endpoint subnet: policies enabled so NSG rules apply to PE traffic
    pe_subnet = {
      name             = "snet-${var.workload}-pe-${var.environment}-westus3-001"
      address_prefixes = [var.subnet_pe_cidr]
      network_security_group = {
        id = module.nsg_pe.resource_id
      }
      private_endpoint_network_policies = "Enabled"
      default_outbound_access_enabled   = false
    }
  }

  diagnostic_settings = {
    to_law = {
      name                  = "diag-to-law"
      workspace_resource_id = module.log_analytics_workspace.resource_id
    }
  }

  tags             = local.common_tags
  enable_telemetry = false
}

# Azure Bastion Standard SKU — Standard is required for NSG compatibility and
# tunneling support (FR-024).  No file copy (disabled for security).
module "bastion" {
  source  = "Azure/avm-res-network-bastionhost/azurerm"
  version = "0.9.0"

  name      = local.bastion_name
  location  = module.resource_group.location
  parent_id = module.resource_group.resource_id

  sku = "Standard"

  ip_configuration = {
    name                   = "ipconfig-${local.bastion_name}"
    subnet_id              = module.virtual_network.subnets["bastion_subnet"].resource_id
    create_public_ip       = true
    public_ip_address_name = "pip-${local.bastion_name}"
  }

  # westus3 does not support Azure Bastion with Availability Zones
  # (BastionRegionAzNotSupported) — override module default ["1","2","3"]
  zones = []

  # Standard SKU features — tunneling enables native client (SSH/RDP) connectivity
  copy_paste_enabled = true
  tunneling_enabled  = true
  file_copy_enabled  = false # File copy disabled for security hardening

  diagnostic_settings = {
    to_law = {
      name                  = "diag-to-law"
      workspace_resource_id = module.log_analytics_workspace.resource_id
    }
  }

  tags             = local.common_tags
  enable_telemetry = false

  depends_on = [module.virtual_network]
}

# ─── Key Vault + VM (US2) ────────────────────────────────────────────────────

# Key Vault — RBAC authorization only (FR-019); legacy Access Policies disabled.
# Public network access is disabled; no private endpoint required for this
# workload (deployment agent accesses KV over service tags).
# The VM admin password is generated by random_password and written here via
# secrets_value.  It is NOT read back from KV state — the VM write-only
# argument receives the value directly from random_password.result (SC-003).
module "key_vault" {
  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "0.10.2"

  name                = local.key_vault_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = var.kv_sku

  # Enable public access so the deploy agent (local workstation) can write the
  # KV secret via the data plane.  Default action remains Deny — only the
  # deployer IP is explicitly allowed.  Private endpoints can be added later
  # to lock this down further for steady-state operations.
  public_network_access_enabled = true

  # Enforce deny-by-default network ACL; allow Azure services for diagnostics.
  # ip_rules: CIDR block for the deployment workstation — required because
  # 'public_network_access_enabled = false' would block ALL public traffic
  # including the Terraform runner (ForbiddenByConnection).
  network_acls = {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = ["174.127.190.39/32"]
  }

  # RBAC authorization is the default in this AVM module (legacy_access_policies_enabled
  # defaults to false).  Legacy Access Policies are explicitly prohibited (FR-019).

  # Grant the deploying principal permission to manage secrets during deployment.
  # Without this, Terraform cannot write the vm_admin_password secret (403 ForbiddenByRbac).
  role_assignments = {
    deploying_principal = {
      role_definition_id_or_name = "Key Vault Secrets Officer"
      principal_id               = data.azurerm_client_config.current.object_id
    }
  }

  # Soft-delete enabled with 7-day retention; purge protection off to allow
  # clean teardown in non-prod (set true in regulated prod environments)
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  # Secret placeholder — value is supplied via secrets_value below
  secrets = {
    vm_admin_password = {
      name = var.vm_admin_password_secret_name
    }
  }

  # Sensitive value — random_password.result is stored in random_password state
  # and forwarded to KV; it does NOT appear in key_vault resource state
  secrets_value = {
    vm_admin_password = random_password.vm_admin_password.result
  }

  diagnostic_settings = {
    to_law = {
      name                  = "diag-to-law"
      workspace_resource_id = module.log_analytics_workspace.resource_id
    }
  }

  tags             = local.common_tags
  enable_telemetry = false
}

# Windows Server 2016 VM — no public IP assigned (FR-011, FR-013).
# Password is passed via write-only account_credentials argument (Terraform
# 1.10+ GA feature) — the value is applied to Azure but is NOT stored in the
# azurerm_windows_virtual_machine resource state entry (SC-003).
module "virtual_machine" {
  source  = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "0.20.0"

  name                = local.vm_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name

  os_type       = "Windows"
  computer_name = var.vm_computer_name # NetBIOS name <= 15 chars per FR-013
  sku_size      = var.vm_sku_size
  zone          = tostring(var.vm_availability_zone) # zone must be string; var is number

  # OS image — Windows Server 2016 Datacenter (FR-007)
  source_image_reference = {
    publisher = var.vm_image_publisher
    offer     = var.vm_image_offer
    sku       = var.vm_image_sku
    version   = "latest"
  }

  # Write-only credentials — password NOT stored in VM resource state (SC-003)
  # generate_admin_password_or_ssh_key = false disables module auto-generation so
  # the custom random_password is used instead (required when supplying a password)
  account_credentials = {
    admin_credentials = {
      username                           = var.vm_admin_username
      password                           = random_password.vm_admin_password.result
      generate_admin_password_or_ssh_key = false
    }
  }

  # OS disk — Standard HDD (FR-008, FR-009)
  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = var.vm_os_disk_type
    name                 = local.vm_os_disk_name
  }

  # Data disk — 500 GB Standard HDD at LUN 0 (FR-009)
  data_disk_managed_disks = {
    data_disk_0 = {
      name                 = local.vm_data_disk_name
      storage_account_type = var.vm_data_disk_type
      disk_size_gb         = var.vm_data_disk_size_gb
      lun                  = 0
      caching              = "None"
    }
  }

  # Single NIC — private IP only, no public IP assigned (FR-011, FR-013)
  network_interfaces = {
    nic_0 = {
      name = local.vm_nic_name
      ip_configurations = {
        ipconfig_0 = {
          name                          = "ipconfig0"
          private_ip_subnet_resource_id = module.virtual_network.subnets["vm_subnet"].resource_id
          private_ip_allocation_method  = "Dynamic"
        }
      }
    }
  }

  diagnostic_settings = {
    to_law = {
      name                  = "diag-to-law"
      workspace_resource_id = module.log_analytics_workspace.resource_id
    }
  }

  tags             = local.common_tags
  enable_telemetry = false

  depends_on = [
    module.key_vault,
    module.virtual_network,
  ]
}

# ─── Storage (US3) ───────────────────────────────────────────────────────────

# Private DNS zone for Azure Files private endpoints.
# Domain = "privatelink.file.core.windows.net" (canonical zone for Azure Files).
# Autoregistration is disabled — only the storage PE record is registered (FR-023).
module "private_dns_zone" {
  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "0.5.0"

  domain_name = local.private_dns_zone_name
  parent_id   = module.resource_group.resource_id

  virtual_network_links = {
    workload_vnet_link = {
      name               = "link-${local.vnet_name}"
      virtual_network_id = module.virtual_network.resource_id
      autoregistration   = false
    }
  }

  tags             = local.common_tags
  enable_telemetry = false

  depends_on = [module.virtual_network]
}

# Storage account — Standard LRS, StorageV2, TLS 1.2, no public access (FR-020–FR-023).
# Access via private endpoint only; shared-key (SAS) access disabled.
# NOTE: shared_access_key_enabled = false requires Kerberos/AADKERB for SMB
# authentication from the VM.  See quickstart.md Step 9 for mapping instructions.
module "storage_account" {
  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.6.7"

  name                = local.storage_account_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name

  account_kind             = "StorageV2"
  account_tier             = "Standard" # Standard tier — FR-020
  account_replication_type = "LRS"      # Locally-redundant storage — FR-020
  min_tls_version          = "TLS1_2"   # Minimum TLS 1.2 enforced — FR-020

  # Disable all public network access — FR-021; access via private endpoint only
  public_network_access_enabled = false

  # Network rules — deny all public traffic; allow Azure services for diagnostics
  network_rules = {
    bypass         = ["AzureServices"]
    default_action = "Deny"
  }

  # Shared key (SAS) access is disabled.  All data-plane operations (including
  # file share creation) use Azure AD auth via provider storage_use_azuread = true
  # (declared in terraform.tf).  See FR-020 and quickstart.md Step 9.
  shared_access_key_enabled = false

  # Azure Files share — 100 GB quota (FR-022)
  shares = {
    workload_share = {
      name  = var.storage_file_share_name
      quota = var.storage_file_share_quota_gb
    }
  }

  # Private endpoint for the "file" sub-resource only — FR-023
  private_endpoints = {
    file_pe = {
      name                          = local.pe_storage_name
      subnet_resource_id            = module.virtual_network.subnets["pe_subnet"].resource_id
      subresource_name              = "file"
      private_dns_zone_resource_ids = toset([module.private_dns_zone.resource_id])
    }
  }

  # Storage account–level diagnostics (metrics only — storage accounts
  # do not support log categories at the account level)
  diagnostic_settings_storage_account = {
    to_law = {
      name                  = "diag-to-law"
      workspace_resource_id = module.log_analytics_workspace.resource_id
      metric_categories     = ["AllMetrics"]
    }
  }

  # Azure Files service–level diagnostics (logs + metrics)
  diagnostic_settings_file = {
    to_law = {
      name                  = "diag-to-law"
      workspace_resource_id = module.log_analytics_workspace.resource_id
    }
  }

  tags             = local.common_tags
  enable_telemetry = false

  depends_on = [module.private_dns_zone]
}

# ─── Observability (US4) ─────────────────────────────────────────────────────

# All diagnostic settings are declared inline with each module call above.
# This section contains only the three native azurerm alert rule resources
# for which no AVM module exists (Constitution Principle II).

# ─── Alerts ──────────────────────────────────────────────────────────────────

# Alert 1: VM stopped / deallocated (FR-027)
# VmAvailabilityMetric = 1 when running, 0 when stopped.  A platform metric —
# no Azure Monitor Agent required.  Fires within alert_vm_metric_window_size
# of the VM transitioning to stopped/deallocated.
resource "azurerm_monitor_metric_alert" "vm_stopped" {
  name                = local.alert_vm_stopped_name
  resource_group_name = module.resource_group.name
  scopes              = [module.virtual_machine.resource_id]
  description         = "Alert fires when the VM is in a stopped/deallocated state."
  severity            = 1 # Critical
  enabled             = true

  frequency   = "PT1M"                          # Evaluation frequency: every 1 minute
  window_size = var.alert_vm_metric_window_size # Configurable window (default PT5M)

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "VmAvailabilityMetric"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 1
  }

  # No action group — portal-only alerts (clarification Q3)
  tags = local.common_tags
}

# Alert 2: Disk free space < threshold (FR-028)
# PREREQUISITE: Azure Monitor Agent (AMA) + Data Collection Rule (DCR) with
# "LogicalDisk % Free Space" counter must be deployed on the VM before this
# alert produces results (FR-030 exception — AMA is a manual post-deploy step,
# see quickstart.md Step 10).
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "disk_low" {
  name                = local.alert_disk_full_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  scopes              = [module.log_analytics_workspace.resource_id]
  description         = "Alert fires when VM disk free space drops below ${var.alert_disk_free_threshold_pct}%."
  severity            = 2 # Warning
  enabled             = true

  evaluation_frequency = var.alert_disk_query_window
  window_duration      = var.alert_disk_query_window

  criteria {
    query = <<-QUERY
      Perf
      | where ObjectName == "LogicalDisk"
          and CounterName == "% Free Space"
          and InstanceName != "_Total"
          and InstanceName != "HarddiskVolume3"
      | where CounterValue < ${var.alert_disk_free_threshold_pct}
      | project TimeGenerated, Computer, InstanceName, CounterValue
    QUERY

    time_aggregation_method = "Count"
    threshold               = 0
    operator                = "GreaterThan"

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  # No action group — portal-only
  tags = local.common_tags
}

# Alert 3: Key Vault access failures (FR-029)
# Fires on any non-200 KV API response (auth failures, authorization denials,
# throttling).  Requires KV audit diagnostic logs enabled (done inline above).
resource "azurerm_monitor_metric_alert" "kv_access_failures" {
  name                = local.alert_kv_failures_name
  resource_group_name = module.resource_group.name
  scopes              = [module.key_vault.resource_id]
  description         = "Alert fires when Key Vault API requests result in failure responses."
  severity            = 2 # Warning
  enabled             = true

  frequency   = "PT5M"                          # Evaluation frequency: every 5 minutes
  window_size = var.alert_kv_metric_window_size # Configurable window (default PT15M)

  criteria {
    metric_namespace = "Microsoft.KeyVault/vaults"
    metric_name      = "ServiceApiResult"
    aggregation      = "Count"
    operator         = "GreaterThan"
    threshold        = 0

    dimension {
      name     = "StatusCode"
      operator = "Exclude"
      values   = ["200"]
    }
  }

  # No action group — portal-only
  tags = local.common_tags
}
