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
  dns_project_id  = coalesce(var.dns_project_id, var.project_id)
  dns_record_name = coalesce(var.dns_record_name, var.bucket_name)

  default_labels = {
    environment = "homolog"
    application = "kardume"
  }

  bucket_labels = merge(local.default_labels, var.bucket_labels)
}

provider "google" {
  alias   = "dns"
  project = local.dns_project_id
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
}

module "dns_record" {
  source = "../../modules/dns"

  providers = {
    google = google.dns
  }

  managed_zone = var.dns_managed_zone
  record_name  = local.dns_record_name
  record_type  = "CNAME"
  ttl          = var.dns_ttl
  rrdatas      = ["c.storage.googleapis.com."]

  depends_on = [module.static_site]
}
