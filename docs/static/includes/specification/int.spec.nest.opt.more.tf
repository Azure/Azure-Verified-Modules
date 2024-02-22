# The nested block is optional and supports one or more instances

# Variable declaration
variable "optional_multi_block" {
  type = map(object({
    name   = string
    color  = string
    length = optional(number)
  }))
  default = null
  ...
}

# Resource declaration
resource "my_resource" "this" {
  ...
  dynamic "optional_multi_block" {
    for_each = var.optional_multi_block != null ? var.optional_multi_block : {}
    content {
      name   = var.optional_multi_block.name
      color  = var.optional_multi_block.color
      length = var.optional_multi_block.length
    }
  }
  ...
}
