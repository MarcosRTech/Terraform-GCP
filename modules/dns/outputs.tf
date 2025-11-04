output "record_fqdn" {
  description = "Fully qualified DNS record created in Cloud DNS."
  value       = google_dns_record_set.this.name
}

output "record_type" {
  description = "Type of the DNS record."
  value       = google_dns_record_set.this.type
}
