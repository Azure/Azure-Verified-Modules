resource "random_string" "name_suffix" {
  length  = 4
  special = false
  upper   = false
}
