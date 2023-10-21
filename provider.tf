# INSTALL REQUIRED PROVIDERS.
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
  backend "gcs" {
    bucket = "brave-terraform-template-terraform"
    prefix = "tf-state"
  }
  required_version = ">= 0.13"
}
