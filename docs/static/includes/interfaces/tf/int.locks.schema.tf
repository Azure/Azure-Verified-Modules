variable "lock" {
  type = object({
    kind = string
    name = optional(string, null)
  })
  default     = null
  description = <<DESCRIPTION
Controls the Resource Lock configuration for this resource. The following properties can be specified:

- `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
- `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.
DESCRIPTION

  validation {
    condition     = var.lock != null ? contains(["CanNotDelete", "ReadOnly"], var.lock.kind) : true
    error_message = "Lock kind must be either `\"CanNotDelete\"` or `\"ReadOnly\"`."
  }
}

module "avm_interfaces" {
  source  = "Azure/avm-utl-interfaces/azure"
  version = "0.6.0" # check latest version at the time of use

  lock       = var.lock
  lock_scope = azapi_resource.this.id
}

# Example resource implementation
resource "azapi_resource" "lock" {
  count = var.lock != null ? 1 : 0

  type      = module.avm_interfaces.lock_azapi.type
  name      = module.avm_interfaces.lock_azapi.name
  parent_id = module.avm_interfaces.lock_azapi.parent_id
  body      = module.avm_interfaces.lock_azapi.body
}
