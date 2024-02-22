# The nested block is required and supports a single instance

# Variable declaration
variable "required_single_block" {
  type = object({
    name   = string
    color  = string
    length = optional(number)
    pets   = map(object(...))
  })
  ...
}

# Resource declaration
resource "my_resource" "this" {
  ...
  required_single_block {
      name   = var.required_single_block.name
      color  = var.required_single_block.color
      length = var.required_single_block.length
  }
  ...
}
