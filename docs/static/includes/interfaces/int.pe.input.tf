private_endpoints = {
  pe1 = {
    role_assignments   = {} # see interfaces/role assignments
    lock               = {} # see interfaces/resource locks
    tags               = {} # see interfaces/tags
    subnet_resource_id = "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{vnetName}/subnets/{subnetName}"
    private_dns_zone_resource_ids = [
      "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{dnsZoneName}"
    ]
    application_security_group_associations = {
      asg1 = "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationSecurityGroups/{asgName}"
    }
    network_interface_name = "nic1"
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
