output "static_site_bucket" {
  description = "Bucket hosting the homologation static website."
  value       = module.static_site.bucket_name
}

output "static_site_website_endpoint" {
  description = "Google-managed endpoint for testing the static website without DNS."
  value       = module.static_site.website_endpoint
}

output "static_site_bucket_url" {
  description = "gs:// URL for the static site bucket."
  value       = module.static_site.bucket_url
}
