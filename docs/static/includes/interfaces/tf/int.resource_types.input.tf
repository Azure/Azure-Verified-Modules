# Consumers override only the keys they need; defaults supply the rest.
# Passing `null` for any attribute (or omitting it) yields the default
# declared on the owning module's variable.
resource_types = {
  # Pin the primary widget to a newer preview API version.
  example_widgets = "Microsoft.Example/widgets@2025-06-01-preview"

  # Override an API version inside the `parts` submodule.
  example_widgets_parts = {
    example_widgets_parts = "Microsoft.Example/widgets/parts@2023-01-01"

    # Override an API version inside the grandchild `components` submodule
    # of `parts` — the nested slot mirrors the submodule tree.
    example_widgets_parts_components = {
      example_widgets_parts_components = "Microsoft.Example/widgets/parts/components@2023-01-01"
    }
  }
}

