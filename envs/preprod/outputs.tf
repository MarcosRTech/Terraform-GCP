output "environment_folder_id" {
  description = "ID (folders/NNN) da pasta criada para o ambiente."
  value       = google_folder.environment.name
}

output "service_projects" {
  description = "Resumo dos projetos por serviço."
  value = {
    for service, module_ref in module.services :
    service => {
      project_id          = module_ref.project_id
      project_number      = module_ref.project_number
      bucket_name         = module_ref.bucket_name
      bucket_url          = module_ref.bucket_url
      website_endpoint    = module_ref.website_endpoint
      lb_ip_address       = module_ref.lb_ip_address
      lb_http_rule        = module_ref.lb_http_forwarding_rule
      lb_https_rule       = module_ref.lb_https_forwarding_rule
      lb_certificate_name = module_ref.lb_certificate_name
    }
  }
}
