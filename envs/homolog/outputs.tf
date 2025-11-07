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

output "static_site_lb_ip" {
  description = "Endereco IPv4 global do load balancer para configurar no DNS."
  value       = module.static_site_lb.ip_address
}

output "static_site_lb_certificate_name" {
  description = "Nome do certificado SSL gerenciado associado ao load balancer."
  value       = module.static_site_lb.certificate_name
}

output "static_site_lb_https_forwarding_rule" {
  description = "Nome da forwarding rule HTTPS que recebe o trafego."
  value       = module.static_site_lb.https_forwarding_rule
}

output "static_site_lb_http_forwarding_rule" {
  description = "Nome da forwarding rule HTTP (redirect ou backend)."
  value       = module.static_site_lb.http_forwarding_rule
}

output "compraplanejada_static_site_bucket" {
  description = "Bucket do site compraplanejada.theklubi.com (caso configurado)."
  value       = var.compraplanejada_site == null ? null : module.compraplanejada_static_site[0].bucket_name
}

output "compraplanejada_static_site_website_endpoint" {
  description = "Endpoint gerenciado pela Google para testar o site compraplanejada sem DNS."
  value       = var.compraplanejada_site == null ? null : module.compraplanejada_static_site[0].website_endpoint
}

output "compraplanejada_static_site_bucket_url" {
  description = "gs:// URL para o bucket do site compraplanejada."
  value       = var.compraplanejada_site == null ? null : module.compraplanejada_static_site[0].bucket_url
}

output "compraplanejada_static_site_lb_ip" {
  description = "Endereco IPv4 global do load balancer do compraplanejada."
  value       = var.compraplanejada_site == null ? null : module.compraplanejada_static_site_lb[0].ip_address
}

output "compraplanejada_static_site_lb_certificate_name" {
  description = "Certificado ligado ao load balancer do compraplanejada."
  value       = var.compraplanejada_site == null ? null : module.compraplanejada_static_site_lb[0].certificate_name
}

output "compraplanejada_static_site_lb_https_forwarding_rule" {
  description = "Forwarding rule HTTPS usada no compraplanejada."
  value       = var.compraplanejada_site == null ? null : module.compraplanejada_static_site_lb[0].https_forwarding_rule
}

output "compraplanejada_static_site_lb_http_forwarding_rule" {
  description = "Forwarding rule HTTP (redirect/backend) do compraplanejada."
  value       = var.compraplanejada_site == null ? null : module.compraplanejada_static_site_lb[0].http_forwarding_rule
}
