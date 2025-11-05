output "bucket_name" {
  description = "Name of the bucket that hosts the static website."
  value       = google_storage_bucket.this.name
}

output "bucket_self_link" {
  description = "Self link of the bucket."
  value       = google_storage_bucket.this.self_link
}

output "bucket_url" {
  description = "gs:// style URL for the bucket."
  value       = "gs://${google_storage_bucket.this.name}"
}

output "website_endpoint" {
  description = "Public endpoint exposed by the Cloud Storage website."
  value       = var.enable_public_access ? "https://${google_storage_bucket.this.name}.storage.googleapis.com" : null
}

output "public_access_enabled" {
  description = "Whether the bucket was configured for public read access."
  value       = var.enable_public_access
}

output "versioning_enabled" {
  description = "Indicates if object versioning is turned on."
  value       = google_storage_bucket.this.versioning[0].enabled
}

output "logging_configured" {
  description = "Indicates if access logging is configured."
  value       = google_storage_bucket.this.logging != null
}
