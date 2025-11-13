output "ip_address" {
  description = "Global IPv4 address to configure in DNS."
  value       = google_compute_global_address.static_site.address
}

output "https_forwarding_rule" {
  description = "Name of the HTTPS forwarding rule."
  value       = var.enable_https ? google_compute_global_forwarding_rule.https[0].name : null
}

output "http_forwarding_rule" {
  description = "Name of the HTTP forwarding rule (redirect ou backend)."
  value = try(
    google_compute_global_forwarding_rule.http_redirect["redirect"].name,
    google_compute_global_forwarding_rule.http_backend["backend"].name,
    null
  )
}

output "certificate_name" {
  description = "Nome do certificado SSL associado ao proxy HTTPS."
  value = var.enable_https ? (
    var.use_managed_ssl_certificate ? google_compute_managed_ssl_certificate.static_site[0].name : (
      var.existing_ssl_certificate_name != null ? data.google_compute_ssl_certificate.existing[0].name : null
    )
  ) : null
}
