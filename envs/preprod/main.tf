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
  region = var.region
}

locals {
  folder_display_name = coalesce(var.folder_display_name, title(var.environment))
}

resource "google_folder" "environment" {
  display_name = local.folder_display_name
  parent       = "organizations/${var.organization_id}"
}

module "services" {
  for_each = var.services
  source   = "../../modules/static-site-service"

  service_name       = each.key
  environment        = var.environment
  project_id         = var.append_environment_to_project_id ? format("%s-%s", each.value.project_id, var.environment) : each.value.project_id
  project_name       = try(each.value.project_name, null)
  project_labels     = try(each.value.project_labels, {})
  project_services   = var.project_services
  billing_account_id = var.billing_account_id
  folder_id          = google_folder.environment.name

  bucket_name                 = each.value.bucket_name
  bucket_location             = coalesce(try(each.value.bucket_location, null), var.default_bucket_location)
  bucket_storage_class        = coalesce(try(each.value.bucket_storage_class, null), var.default_bucket_storage_class)
  bucket_force_destroy        = coalesce(try(each.value.bucket_force_destroy, null), var.default_bucket_force_destroy)
  bucket_enable_public_access = coalesce(try(each.value.bucket_enable_public_access, null), var.default_bucket_enable_public_access)
  bucket_enable_versioning    = coalesce(try(each.value.bucket_enable_versioning, null), var.default_bucket_enable_versioning)
  bucket_website_main_page    = coalesce(try(each.value.bucket_website_main_page, null), var.default_website_main_page)
  bucket_website_error_page   = coalesce(try(each.value.bucket_website_error_page, null), var.default_website_error_page)
  bucket_log_bucket           = try(each.value.bucket_log_bucket, null)
  bucket_log_prefix           = try(each.value.bucket_log_prefix, null)
  bucket_labels               = merge(var.default_bucket_labels, try(each.value.bucket_labels, {}))
  additional_bucket_viewers   = coalesce(try(each.value.additional_bucket_viewers, null), var.default_additional_bucket_viewers)

  cdn_hostnames                     = each.value.cdn_hostnames
  cdn_name                          = coalesce(try(each.value.cdn_name, null), each.value.bucket_name)
  cdn_enable_http_redirect          = coalesce(try(each.value.cdn_enable_http_redirect, null), var.default_cdn_enable_http_redirect)
  cdn_enable_http_backend           = coalesce(try(each.value.cdn_enable_http_backend, null), var.default_cdn_enable_http_backend)
  cdn_enable_https                  = coalesce(try(each.value.cdn_enable_https, null), var.default_cdn_enable_https)
  cdn_use_managed_ssl_certificate   = coalesce(try(each.value.cdn_use_managed_ssl_certificate, null), var.default_cdn_use_managed_ssl_certificate)
  cdn_existing_ssl_certificate_name = try(each.value.cdn_existing_ssl_certificate_name, null)
  cdn_enable_logging                = coalesce(try(each.value.cdn_enable_logging, null), var.default_cdn_enable_logging)
  cdn_log_sample_rate               = coalesce(try(each.value.cdn_log_sample_rate, null), var.default_cdn_log_sample_rate)
  cdn_cache_default_ttl             = coalesce(try(each.value.cdn_cache_default_ttl, null), var.default_cdn_cache_default_ttl)
  cdn_cache_max_ttl                 = coalesce(try(each.value.cdn_cache_max_ttl, null), var.default_cdn_cache_max_ttl)
  cdn_cache_negative_ttl            = coalesce(try(each.value.cdn_cache_negative_ttl, null), var.default_cdn_cache_negative_ttl)
}
