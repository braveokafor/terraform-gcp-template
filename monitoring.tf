resource "google_monitoring_notification_channel" "email_notification_channel" {
  for_each = toset(var.notification_emails)
  project  = var.project_id

  display_name = "${each.value}'s notification channel"
  type         = "email"

  labels = {
    email_address = each.value
  }
}
