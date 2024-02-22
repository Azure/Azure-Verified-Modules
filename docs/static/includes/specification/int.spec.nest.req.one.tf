# The resource requires a single nested block

# Variable declaration
# No default value, as it is required in the module.
# Uses an object type to support a single instance.
variable "required_single_block" {
  type = object({
    name   = string
    length = optional(number)
  })
}

# Resource declaration
# The block is used directly, as only one instance is supported and required.
resource "my_resource" "this" {

  required_single_block {
    name   = var.required_single_block.name
    length = var.required_single_block.length
  }
}
