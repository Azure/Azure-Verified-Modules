# The nested block is optional and supports a single instance

# Variable declaration
variable "optional_single_block" {
  type = object({
    name   = string
    color  = string
    length = optional(number)
  })
  default = null
  ...
}

# Resource declaration
resource "my_resource" "this" {
  ...
  dynamic "optional_single_block" {
    for_each = var.optional_single_block != null ? { this = var.optional_single_block } : {}
    content {
      name   = var.optional_single_block.name
      color  = var.optional_single_block.color
      length = var.optional_single_block.length
    }
  }
  ...
}
