# The nested block is required and supports one or more instances

# Variable declaration
variable "required_multi_blocks" {
  type = map(object({
    name   = string
    color  = string
    length = optional(number)
  }))
  ...
}

# Resource declaration
resource "my_resource" "this" {
  ...
  dynamic "required_multi_blocks" {
    for_each = var.required_multi_blocks
    content {
      name   = var.required_multi_blocks.name
      color  = var.required_multi_blocks.color
      length = var.required_multi_blocks.length
    }
  }
  ...
}
