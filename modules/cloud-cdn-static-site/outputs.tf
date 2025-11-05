output "ip_address" {
  description = "Global IPv4 address to configure in DNS."
  value       = google_compute_global_address.static_site.address
}

output "https_forwarding_rule" {
  description = "Name of the HTTPS forwarding rule."
  value       = google_compute_global_forwarding_rule.https.name
}

output "certificate_name" {
  description = "Managed SSL certificate resource name."
  value       = google_compute_managed_ssl_certificate.static_site.name
}
