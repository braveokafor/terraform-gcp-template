variable "project_id" {
  type        = string
  description = "The ID of the project"
}

variable "enabled_apis" {
  description = "Google Cloud API's to enable on the project."
  type        = list(string)
  default = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "vpcaccess.googleapis.com",
  ]
}
