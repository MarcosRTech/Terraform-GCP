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

  bucket_labels                 = merge(local.default_labels, var.bucket_labels)
  cdn_name                      = coalesce(var.cdn_name, var.bucket_name)
  compraplanejada_enabled       = var.compraplanejada_site != null
  compraplanejada_bucket_labels = local.compraplanejada_enabled ? merge(local.default_labels, try(var.compraplanejada_site.bucket_labels, {})) : {}
  compraplanejada_cdn_name = local.compraplanejada_enabled ? coalesce(
    try(var.compraplanejada_site.cdn_name, null),
    var.compraplanejada_site.bucket_name
  ) : null
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

module "compraplanejada_static_site" {
  count  = local.compraplanejada_enabled ? 1 : 0
  source = "../../modules/storage-static-site"

  project_id           = var.project_id
  bucket_name          = var.compraplanejada_site.bucket_name
  location             = coalesce(try(var.compraplanejada_site.bucket_location, null), var.bucket_location)
  storage_class        = coalesce(try(var.compraplanejada_site.storage_class, null), var.storage_class)
  labels               = local.compraplanejada_bucket_labels
  force_destroy        = try(var.compraplanejada_site.force_destroy, var.force_destroy)
  website_main_page    = try(var.compraplanejada_site.website_main_page, var.website_main_page)
  website_error_page   = try(var.compraplanejada_site.website_error_page, var.website_error_page)
  enable_public_access = try(var.compraplanejada_site.enable_public_access, var.enable_public_access)
  enable_versioning    = try(var.compraplanejada_site.enable_bucket_versioning, var.enable_bucket_versioning)
  log_bucket           = try(var.compraplanejada_site.bucket_log_bucket, var.bucket_log_bucket)
  log_object_prefix    = try(var.compraplanejada_site.bucket_log_prefix, var.bucket_log_prefix)
  object_viewers       = []
}

module "compraplanejada_static_site_lb" {
  count  = local.compraplanejada_enabled ? 1 : 0
  source = "../../modules/cloud-cdn-static-site"

  project_id                    = var.project_id
  name                          = local.compraplanejada_cdn_name
  bucket_name                   = module.compraplanejada_static_site[0].bucket_name
  hostnames                     = var.compraplanejada_site.cdn_hostnames
  enable_http_redirect          = try(var.compraplanejada_site.cdn_enable_http_redirect, var.cdn_enable_http_redirect)
  enable_http_backend           = try(var.compraplanejada_site.cdn_enable_http_backend, var.cdn_enable_http_backend)
  use_managed_ssl_certificate   = try(var.compraplanejada_site.cdn_use_managed_ssl_certificate, var.cdn_use_managed_ssl_certificate)
  existing_ssl_certificate_name = try(var.compraplanejada_site.cdn_existing_ssl_certificate_name, null)
}
