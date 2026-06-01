variable "retry" {
  type = object({
    error_message_regex  = optional(list(string))
    interval_seconds     = optional(number)
    max_interval_seconds = optional(number)
  })
  default     = null
  description = <<DESCRIPTION
Retry configuration applied to every `azapi` resource managed by the module (root resource and all submodules). Defaults to `null` (no custom retry).

- `error_message_regex`  - (Optional) A list of regex patterns matching error messages that trigger a retry.
- `interval_seconds`     - (Optional) Initial interval between retries in seconds.
- `max_interval_seconds` - (Optional) Maximum interval between retries in seconds.

See <https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource#retry> for full semantics.
DESCRIPTION
}

# Example resource implementation. `retry` is an attribute on `azapi_resource`,
# so the variable is assigned directly. The same pattern applies to every
# `azapi_resource` declared by the module, including those in submodules.
resource "azapi_resource" "this" {
  type      = var.resource_types.example_widgets
  name      = var.name
  parent_id = var.parent_id
  body      = { /* ... */ }

  retry = var.retry

  response_export_values = []
}

# Cascade `retry` to every submodule the parent module instantiates so that a
# single override at the parent level propagates everywhere.
module "child" {
  source = "./modules/child"

  retry = var.retry

  # ...other arguments...
}
