terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.40"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

locals {
  default_labels = {
    environment = "homolog"
    application = "kardume"
  }

  bucket_labels = merge(local.default_labels, var.bucket_labels)
}

module "static_site" {
  source = "../../modules/storage-static-site"

  project_id           = var.project_id
  bucket_name          = var.bucket_name
  location             = var.bucket_location
  storage_class        = var.storage_class
  labels               = local.bucket_labels
  force_destroy        = var.force_destroy
  website_main_page    = var.website_main_page
  website_error_page   = var.website_error_page
  enable_public_access = var.enable_public_access
  enable_versioning    = var.enable_bucket_versioning
  log_bucket           = var.bucket_log_bucket
  log_object_prefix    = var.bucket_log_prefix
  object_viewers       = []
}
