output "resource_group_name" {
  value =  module.avm-res-resources-resourcegroup.name
  description = "The resource group name where the resources are deployed"
}

output "virtual_machine_name" {
    value = module.avm-res-compute-virtualmachine.name
    description = "The name of the virtual machine"
}
