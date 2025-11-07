variable "project_id" {
  description = "Project ID where the load balancer and CDN resources will live."
  type        = string
}

variable "name" {
  description = "Base name used to construct resource identifiers."
  type        = string
}

variable "bucket_name" {
  description = "Name of the Cloud Storage bucket backing the CDN."
  type        = string
}

variable "hostnames" {
  description = "Fully qualified domain names served by the CDN (e.g. www.example.com)."
  type        = list(string)
}

variable "enable_http_redirect" {
  description = "Provision HTTP listener that redirects traffic to HTTPS."
  type        = bool
  default     = true
}

variable "enable_http_backend" {
  description = "Provision HTTP listener que atende o conteudo diretamente (sem redirecionar)."
  type        = bool
  default     = false
}

variable "use_managed_ssl_certificate" {
  description = "Quando verdadeiro, cria um certificado gerenciado pelo Google para os hostnames informados."
  type        = bool
  default     = true
}

variable "existing_ssl_certificate_name" {
  description = "Nome do certificado SSL (global) ja existente no GCP para ser reutilizado quando use_managed_ssl_certificate=false."
  type        = string
  default     = null
}

variable "enable_logging" {
  description = "Enable Cloud CDN request logging."
  type        = bool
  default     = true
}

variable "log_sample_rate" {
  description = "Sampling rate for CDN logging (0.0 - 1.0)."
  type        = number
  default     = 1.0
}

variable "cache_default_ttl" {
  description = "Default cache TTL in seconds."
  type        = number
  default     = 3600
}

variable "cache_max_ttl" {
  description = "Maximum cache TTL in seconds."
  type        = number
  default     = 86400
}

variable "cache_negative_ttl" {
  description = "TTL for negative caching (e.g., 404 errors)."
  type        = number
  default     = 300
}
