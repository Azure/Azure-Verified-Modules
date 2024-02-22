# The nested block is required and supports only a single instance
# Use the nested block directly without a dynamic block and looping.

# Variable declaration
Variable "my_nested_block" {

}

# Resource implementation
resource "my_resource" "this" {
    
}



# The nested block is required and supports one or more instances
# Use a dynamic block with a `for_each` meta argument. As it requires atleast one input, the definition can be `for_each = var.loop_me`

# The nested block is optional and supports only a single instance
# Use a dynamic block with a `for_each` meta argument.
# As its input is optional, the definision **SHOULD** be `for_each = var.loop_me != null ? { this = var.loop_me } : {}`

# The nested block is optional and supports one or more instance
# Use a dynamic block with a `for_each` meta argument.
# As its input is optional and supports multiple, the definition **SHOULD** be `for_each = var.loop_me != null ? var.loop_me : {}`. 
# Where the input parameter is a `map()` type.