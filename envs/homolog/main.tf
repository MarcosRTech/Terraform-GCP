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
  cdn_name      = coalesce(var.cdn_name, var.bucket_name)
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

module "static_site_lb" {
  source = "../../modules/cloud-cdn-static-site"

  project_id                    = var.project_id
  name                          = local.cdn_name
  bucket_name                   = module.static_site.bucket_name
  hostnames                     = var.cdn_hostnames
  enable_http_redirect          = var.cdn_enable_http_redirect
  enable_http_backend           = var.cdn_enable_http_backend
  use_managed_ssl_certificate   = var.cdn_use_managed_ssl_certificate
  existing_ssl_certificate_name = var.cdn_existing_ssl_certificate_name
}
