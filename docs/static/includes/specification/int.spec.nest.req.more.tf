# The resource requires one or more nested blocks

# Variable declaration
# No default value, as it is required in the module.
# Uses a map type to support multiple instances.
variable "required_multi_blocks" {
  type = map(object({
    name   = string
    length = optional(number)
  }))
}

# Resource declaration
# The dynamic block is used, as there are multiple instances.
resource "my_resource" "this" {
  dynamic "required_multi_blocks" {
    for_each = var.required_multi_blocks
    content {
      name   = required_multi_blocks.value.name
      length = required_multi_blocks.value.length
    }
  }
}
