# The resource supports a single optional nested block

# Variable declaration
# Default value is null, as it is optional and should not configure anything by default.
# It uses an object type to support a single instance.
variable "optional_single_block" {
  type = object({
    name   = string
    length = optional(number)
  })
  default = null
}

# Resource declaration
# The dynamic block provides the optionality.
# The `this` key is used to access the current instance and maps the content to the name of the block.
resource "my_resource" "this" {
  dynamic "optional_single_block" {
    for_each = var.optional_single_block != null ? { this = var.optional_single_block } : {}
    content {
      name   = optional_single_block.value.name
      length = optional_single_block.value.length
    }
  }
}
