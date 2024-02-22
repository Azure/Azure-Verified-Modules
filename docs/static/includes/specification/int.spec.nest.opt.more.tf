# The resource supports one or more optional nested blocks

# Variable declaration
# Default value is null, as it is optional and should not configure anything by default.
# Uses a map type to support multiple instances.
variable "optional_multi_block" {
  type = map(object({
    name   = string
    length = optional(number)
  }))
  default = null
}

# Resource declaration
# The dynamic block is used to support the optionality and looping.
resource "my_resource" "this" {
  dynamic "optional_multi_block" {
    for_each = var.optional_multi_block != null ? var.optional_multi_block : {}
    content {
      name   = optional_multi_block.value.name
      length = optional_multi_block.value.length
    }
  }
}
