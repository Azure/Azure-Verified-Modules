variable "my_complex_input" {
  type = map(object({
    param1 = string
    param2 = optional(number, null)
  }))
  description = <<DESCRIPTION
A complex input variable that is a map of objects.
Each object has two attributes:

- `param1`: A required string parameter.
- `param2`: (Optional) An optional number parameter.

Example Input:

```terraform
my_complex_input = {
  "object1" = {
    param1 = "value1"
    param2 = 2
  }
  "object2" = {
    param1 = "value2"
  }
}
```
DESCRIPTION
}
