resource "google_billing_budget" "budget" {
  count = var.enable_budget && var.billing_account_id != "" ? 1 : 0

  billing_account = var.billing_account_id
  display_name    = "${var.prefix}-billing-budget-${var.project_id}"

  budget_filter {
    projects = ["projects/${data.google_project.project.number}"]
  }

  amount {
    specified_amount {
      currency_code = var.budget_currency
      units         = var.monthly_budget
    }
  }

  dynamic "threshold_rules" {
    for_each = var.budget_alert_thresholds
    content {
      threshold_percent = threshold_rules.value
    }
  }

  all_updates_rule {
    monitoring_notification_channels = [for k, v in google_monitoring_notification_channel.email_notification_channel : v.id] //google_monitoring_notification_channel.email_notification_channel[*].id
  }

  depends_on = [
    google_project_service.enable_apis
  ]
}
