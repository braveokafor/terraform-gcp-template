variable "project_id" {
  type        = string
  description = "The ID of the project"
}

variable "prefix" {
  type        = string
  description = "Prefix to prepend to resource names"
  default     = "main"
}

variable "region" {
  type        = string
  description = "Default region for resources"
  default     = "us-central1"
}

variable "labels" {
  description = "Common Labels"
  type        = map(string)
  default = {
    "created-by" = "Terraform"
  }
}

#------------------------------------------------------------------------------
# Services (API's)
#------------------------------------------------------------------------------
variable "enabled_apis" {
  type        = list(string)
  description = "Google Cloud API's to enable on the project."
  default = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "vpcaccess.googleapis.com",
    "servicenetworking.googleapis.com",
    "billingbudgets.googleapis.com",
  ]
}

#------------------------------------------------------------------------------
# Network
#------------------------------------------------------------------------------
variable "enable_subnet_flow_logs" {
  type        = bool
  description = "Should subnet flow logs be enabled"
  default     = false
}

variable "enable_nat_logs" {
  type        = bool
  description = "Should Cloud NAT logs be enabled"
  default     = false
}

#------------------------------------------------------------------------------
# Firewall
#------------------------------------------------------------------------------
variable "enable_firewall_ingress_logs" {
  type        = bool
  description = "Should firewall logs be enabled for ingress traffic"
  default     = false
}

#------------------------------------------------------------------------------
# Budget
#------------------------------------------------------------------------------
variable "enable_budget" {
  type        = bool
  description = "Create a budget"
  default     = false
}

variable "billing_account_id" {
  type        = string
  description = "The ID of the Billing Account"
  default     = ""
}

variable "budget_currency" {
  type        = string
  description = "The 3-letter currency code as defined in ISO 4217"
  default     = "USD"
}

variable "monthly_budget" {
  type        = string
  description = "Monthly budget"
  default     = "100"
}

variable "budget_alert_thresholds" {
  type        = list(number)
  default     = [0.5, 0.75, 0.95, 1]
  description = "What points should billing alerts be sent"
}

#------------------------------------------------------------------------------
# IAM
#------------------------------------------------------------------------------
variable "admin_users" {
  type        = list(string)
  description = "Email address of admin users"
  default     = []
}

variable "dev_users" {
  type        = list(string)
  description = "Email address of dev (developer) users"
  default     = []
}

variable "basic_users" {
  type        = list(string)
  description = "Email address of basic users"
  default     = []
}

variable "admin_user_roles" {
  type        = list(string)
  description = "Admin user roles"
  default     = ["roles/owner"]
}

variable "dev_user_roles" {
  type        = list(string)
  description = "Dev (developer) user roles"
  default     = ["roles/editor"]
}

variable "basic_user_roles" {
  type        = list(string)
  description = "Admin user roles"
  default     = ["roles/viewer"]
}

#------------------------------------------------------------------------------
# Monitoring
#------------------------------------------------------------------------------
variable "notification_emails" {
  type        = list(string)
  description = "Email addresses to send notifications to"
}
