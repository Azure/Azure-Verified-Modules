# The resource has nested dynamic blocks

# Variable declaration
variable "optional_multi_block" {
  type = map(object({
    name         = string
    length       = optional(number)
    nested_block = optional(object(any))
    nested_multi_blocks = optional(map(object({
      name   = string
      length = optional(number)
    })))
  }))
  default = null
}

# Resource declaration
resource "my_resource" "this" {
  dynamic "optional_multi_block" {
    for_each = var.optional_multi_block != null ? var.optional_multi_block : {}
    content {
      name   = var.optional_multi_block.name
      length = var.optional_multi_block.length

      dynamic "nested_block" {
        for_each = try(optional_multi_block.value.nested_block, null) != null ? { this = var.optional_multi_block.value.nested_block } : {}

        content {
          name   = var.optional_multi_block.value.nested_block.name
          length = var.optional_multi_block.value.nested_block.length
        }
      }

      dynamic "nested_multi_blocks" {
        for_each = try(optional_multi_block.value.nested_multi_blocks, null) != null ? var.optional_multi_block.value.nested_multi_blocks : {}

        content {
          name   = nested_multi_blocks.value.name
          length = nested_multi_blocks.value.length
        }
      }
    }
  }
}
