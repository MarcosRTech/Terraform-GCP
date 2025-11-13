variable "organization_id" {
  description = "ID da organização GCP (somente números)."
  type        = string
}

variable "billing_account_id" {
  description = "Conta de faturamento a ser associada aos projetos."
  type        = string
}

variable "region" {
  description = "Região padrão para recursos regionais."
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "Nome do ambiente (homolog, preprod, production)."
  type        = string
}

variable "folder_display_name" {
  description = "Nome exibido para a pasta do ambiente (opcional)."
  type        = string
  default     = null
}

variable "append_environment_to_project_id" {
  description = "Quando verdadeiro, sufixa automaticamente o nome do ambiente no project_id informado em services."
  type        = bool
  default     = false
}

variable "project_services" {
  description = "APIs habilitadas em cada projeto criado."
  type        = list(string)
  default = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "servicemanagement.googleapis.com",
    "serviceusage.googleapis.com",
    "storage.googleapis.com"
  ]
}

variable "default_bucket_location" {
  description = "Localização padrão para os buckets dos serviços."
  type        = string
  default     = "US"
}

variable "default_bucket_storage_class" {
  description = "Classe de armazenamento padrão."
  type        = string
  default     = "STANDARD"
}

variable "default_bucket_force_destroy" {
  description = "Remove buckets mesmo com objetos (uso com cautela)."
  type        = bool
  default     = true
}

variable "default_bucket_enable_public_access" {
  description = "Define se os objetos serão públicos por padrão."
  type        = bool
  default     = true
}

variable "default_bucket_enable_versioning" {
  description = "Ativa versionamento de objetos por padrão."
  type        = bool
  default     = true
}

variable "default_website_main_page" {
  description = "Página principal padrão dos sites."
  type        = string
  default     = "index.html"
}

variable "default_website_error_page" {
  description = "Página de erro padrão dos sites."
  type        = string
  default     = "index.html"
}

variable "default_bucket_labels" {
  description = "Rótulos aplicados a todos os buckets (podem ser sobrescritos por serviço)."
  type        = map(string)
  default     = {}
}

variable "default_additional_bucket_viewers" {
  description = "Lista padrão de membros com acesso leitura aos buckets."
  type        = list(string)
  default     = []
}

variable "default_cdn_enable_http_redirect" {
  description = "Valor padrão para habilitar redirect HTTP->HTTPS."
  type        = bool
  default     = false
}

variable "default_cdn_enable_http_backend" {
  description = "Valor padrão para expor backend HTTP."
  type        = bool
  default     = true
}

variable "default_cdn_enable_https" {
  description = "Controla se o listener HTTPS é criado por padrão."
  type        = bool
  default     = false
}

variable "default_cdn_use_managed_ssl_certificate" {
  description = "Define se certificados gerenciados são usados por padrão."
  type        = bool
  default     = false
}

variable "default_cdn_enable_logging" {
  description = "Ativa logging de requisições do CDN por padrão."
  type        = bool
  default     = true
}

variable "default_cdn_log_sample_rate" {
  description = "Taxa de amostragem padrão para logs do CDN."
  type        = number
  default     = 1.0
}

variable "default_cdn_cache_default_ttl" {
  description = "TTL padrão de cache (segundos)."
  type        = number
  default     = 3600
}

variable "default_cdn_cache_max_ttl" {
  description = "TTL máximo padrão de cache (segundos)."
  type        = number
  default     = 86400
}

variable "default_cdn_cache_negative_ttl" {
  description = "TTL padrão para respostas negativas."
  type        = number
  default     = 300
}

variable "services" {
  description = "Definição dos serviços (projetos) gerenciados no ambiente."
  type = map(object({
    project_id                        = string
    project_name                      = optional(string)
    project_labels                    = optional(map(string))
    bucket_name                       = string
    bucket_location                   = optional(string)
    bucket_storage_class              = optional(string)
    bucket_force_destroy              = optional(bool)
    bucket_enable_public_access       = optional(bool)
    bucket_enable_versioning          = optional(bool)
    bucket_website_main_page          = optional(string)
    bucket_website_error_page         = optional(string)
    bucket_log_bucket                 = optional(string)
    bucket_log_prefix                 = optional(string)
    bucket_labels                     = optional(map(string))
    additional_bucket_viewers         = optional(list(string))
    cdn_hostnames                     = list(string)
    cdn_name                          = optional(string)
    cdn_enable_http_redirect          = optional(bool)
    cdn_enable_http_backend           = optional(bool)
    cdn_enable_https                  = optional(bool)
    cdn_use_managed_ssl_certificate   = optional(bool)
    cdn_existing_ssl_certificate_name = optional(string)
    cdn_enable_logging                = optional(bool)
    cdn_log_sample_rate               = optional(number)
    cdn_cache_default_ttl             = optional(number)
    cdn_cache_max_ttl                 = optional(number)
    cdn_cache_negative_ttl            = optional(number)
  }))
}
