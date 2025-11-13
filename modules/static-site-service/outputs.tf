output "project_id" {
  description = "ID do projeto criado para o serviço."
  value       = google_project.this.project_id
}

output "project_number" {
  description = "Número do projeto criado."
  value       = google_project.this.number
}

output "bucket_name" {
  description = "Bucket GCS utilizado pelo site."
  value       = module.static_site.bucket_name
}

output "bucket_url" {
  description = "URL gs:// do bucket."
  value       = module.static_site.bucket_url
}

output "website_endpoint" {
  description = "Endpoint público direto do bucket (quando aplicável)."
  value       = module.static_site.website_endpoint
}

output "lb_ip_address" {
  description = "Endereço IPv4 global do load balancer."
  value       = module.static_site_lb.ip_address
}

output "lb_http_forwarding_rule" {
  description = "Forwarding rule HTTP criada para o serviço."
  value       = module.static_site_lb.http_forwarding_rule
}

output "lb_https_forwarding_rule" {
  description = "Forwarding rule HTTPS (caso habilitada)."
  value       = module.static_site_lb.https_forwarding_rule
}

output "lb_certificate_name" {
  description = "Nome do certificado associado ao HTTPS (se existir)."
  value       = module.static_site_lb.certificate_name
}
