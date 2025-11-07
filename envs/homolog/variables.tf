variable "project_id" {
  description = "GCP project ID where homologation resources will be created."
  type        = string
}

variable "region" {
  description = "Default region used by the Google provider."
  type        = string
}

variable "bucket_name" {
  description = "Bucket name that will host the homologation static website."
  type        = string
}

variable "bucket_location" {
  description = "Location/region for the Cloud Storage bucket."
  type        = string
}

variable "storage_class" {
  description = "Storage class for the static website bucket."
  type        = string
  default     = "STANDARD"
}

variable "bucket_labels" {
  description = "Labels to add to the storage bucket."
  type        = map(string)
  default     = {}
}

variable "force_destroy" {
  description = "Force bucket deletion even if it contains objects."
  type        = bool
  default     = false
}

variable "website_main_page" {
  description = "Main page served by the static website."
  type        = string
  default     = "index.html"
}

variable "website_error_page" {
  description = "Error page served by the static website."
  type        = string
  default     = "404.html"
}

variable "enable_public_access" {
  description = "When true, grants public read access to the bucket (not recommended when using the CDN)."
  type        = bool
  default     = false
}

variable "enable_bucket_versioning" {
  description = "Enable object versioning on the static site bucket."
  type        = bool
  default     = true
}

variable "bucket_log_bucket" {
  description = "Optional bucket to receive access logs from the static bucket."
  type        = string
  default     = null
}

variable "bucket_log_prefix" {
  description = "Optional prefix for access logs."
  type        = string
  default     = null
}

variable "cdn_hostnames" {
  description = "Lista de dominios (FQDNs) que o load balancer ira atender e que terao certificado gerenciado."
  type        = list(string)

  validation {
    condition     = length(var.cdn_hostnames) > 0
    error_message = "Defina pelo menos um hostname completo para provisionar o load balancer (ex: \"app-hml.seudominio.com\")."
  }
}

variable "cdn_name" {
  description = "Nome base utilizado para nomear os recursos do load balancer (padrao: bucket_name)."
  type        = string
  default     = null
}

variable "cdn_enable_http_redirect" {
  description = "Quando verdadeiro, cria listener HTTP que redireciona todo trafego para HTTPS."
  type        = bool
  default     = true
}

variable "cdn_enable_http_backend" {
  description = "Quando verdadeiro, expoe o conteudo via HTTP usando o mesmo backend (sem redirecionamento)."
  type        = bool
  default     = false
}

variable "cdn_use_managed_ssl_certificate" {
  description = "Quando verdadeiro, deixa o Google gerenciar o certificado SSL automaticamente."
  type        = bool
  default     = true
}

variable "cdn_existing_ssl_certificate_name" {
  description = "Nome do certificado SSL global ja importado no GCP (use quando nao estiver usando certificado gerenciado)."
  type        = string
  default     = null
}
