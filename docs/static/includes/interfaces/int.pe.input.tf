private_endpoints = {
  pe1 = {
    diagnostic_settings = {} # see interfaces/diagnostic settings
    role_assignments    = {} # see interfaces/role assignments
    lock                = "CanNotDelete"
    tags                = {} # see interfaces/tags
    subnet_resource_id  = "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{vnetName}/subnets/{subnetName}"
    private_dns_zone_resource_ids = {
      pnds1 = {
        resource_id = "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{dnsZoneName}"
      }
    }
    application_security_group_resource_ids = {
      asg1 = {
        resource_id = "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationSecurityGroups/{asgName}"
      }
    }
    custom_dns_configs = {
      fqdn1 = {
        fqdn = "fqdn1.example.com"
        ip_addresses = [
          "10.0.0.1",
          "10.0.0.2"
        ]
      }
    }
    custom_network_interface_name = "nic1"
    ip_configurations = {
      ipconfig1 = {
        name               = "ipconfig1"
        group_id           = "vault"
        member_name        = "default"
        private_ip_address = "10.0.0.7"
      }
    }
  }
}
