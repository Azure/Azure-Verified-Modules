# Module-level defaults example: a hypothetical SQL Database module ships
# longer create / delete timeouts because provisioning and dropping large
# databases can exceed the provider defaults. The overall variable default
# is `{}` (not `null`) so the per-field defaults take effect, and consumers
# can still override any individual field.
variable "timeouts" {
  type = object({
    create = optional(string, "1h")
    read   = optional(string, "5m")
    update = optional(string, "1h")
    delete = optional(string, "45m")
  })
  default     = {}
  description = <<DESCRIPTION
Default per-operation timeouts applied to every `azapi` resource managed by the module. This module ships defaults tuned for SQL Database provisioning latency; consumers **MAY** override any field.

- `create` - (Optional) Timeout for create operations.
- `read`   - (Optional) Timeout for read operations.
- `update` - (Optional) Timeout for update operations.
- `delete` - (Optional) Timeout for delete operations.
DESCRIPTION
}
