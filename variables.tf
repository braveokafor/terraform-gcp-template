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
