ignore_body_changes = {
  # Tags are applied to the widget by Azure Policy, so suppress the diff when
  # the consumer opts in. `lifecycle.ignore_changes` cannot express this,
  # because the value is derived from a variable.
  example_widgets = var.ignore_policy_tags ? ["tags"] : []

  example_widgets_parts = {
    example_widgets_parts = ["properties.retentionPolicy"]
  }
}
