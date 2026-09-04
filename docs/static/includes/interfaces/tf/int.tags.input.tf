tags = {
  key           = "value"
  "another-key" = "another-value"
  integers      = "123"
}
resource_tags = {
  resources = {
    this = {
      key = "root-resource-value"
    }
    child = {}
  }
  modules = {
    child = {
      resources = {
        this = {
          key = "child-module-resource-value"
        }
      }
    }
  }
}
