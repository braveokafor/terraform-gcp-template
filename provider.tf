# INSTALL REQUIRED PROVIDERS.
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  backend "gcs" {
    bucket = "your-state-bucket" //Change to your state bucket, or delete the backend section to use local state.
    prefix = "tf-state"
  }
  required_version = ">= 0.13"
}

provider "google" {
  billing_project       = var.project_id
  user_project_override = true
}
