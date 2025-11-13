locals {
  default_labels = {
    environment = var.environment
    service     = var.service_name
  }

  project_labels = merge(local.default_labels, var.project_labels)
  bucket_labels  = merge(local.default_labels, var.bucket_labels)
  project_name   = coalesce(var.project_name, title(var.service_name))
}

resource "google_project" "this" {
  project_id          = var.project_id
  name                = local.project_name
  folder_id           = var.folder_id
  billing_account     = var.billing_account_id
  auto_create_network = false

  labels = local.project_labels
}

resource "google_project_service" "services" {
  for_each = toset(var.project_services)

  project                    = google_project.this.project_id
  service                    = each.value
  disable_on_destroy         = false
  disable_dependent_services = true
}

module "static_site" {
  source = "../storage-static-site"

  project_id           = google_project.this.project_id
  bucket_name          = var.bucket_name
  location             = var.bucket_location
  storage_class        = var.bucket_storage_class
  labels               = local.bucket_labels
  force_destroy        = var.bucket_force_destroy
  website_main_page    = var.bucket_website_main_page
  website_error_page   = var.bucket_website_error_page
  enable_public_access = var.bucket_enable_public_access
  enable_versioning    = var.bucket_enable_versioning
  log_bucket           = var.bucket_log_bucket
  log_object_prefix    = var.bucket_log_prefix
  object_viewers       = var.additional_bucket_viewers

  depends_on = [google_project_service.services]
}

module "static_site_lb" {
  source = "../cloud-cdn-static-site"

  project_id                    = google_project.this.project_id
  name                          = coalesce(var.cdn_name, var.bucket_name)
  bucket_name                   = module.static_site.bucket_name
  hostnames                     = var.cdn_hostnames
  enable_https                  = var.cdn_enable_https
  enable_http_redirect          = var.cdn_enable_http_redirect
  enable_http_backend           = var.cdn_enable_http_backend
  use_managed_ssl_certificate   = var.cdn_use_managed_ssl_certificate
  existing_ssl_certificate_name = var.cdn_existing_ssl_certificate_name
  enable_logging                = var.cdn_enable_logging
  log_sample_rate               = var.cdn_log_sample_rate
  cache_default_ttl             = var.cdn_cache_default_ttl
  cache_max_ttl                 = var.cdn_cache_max_ttl
  cache_negative_ttl            = var.cdn_cache_negative_ttl

  depends_on = [google_project_service.services]
}
