retry = {
  error_message_regex  = ["ScopeLocked", "RetryableError"]
  interval_seconds     = 15
  max_interval_seconds = 60
}
