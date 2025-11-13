variable "service_name" {
  description = "Nome curto do serviço (ex.: kardume, app, etc.)."
  type        = string
}

variable "environment" {
  description = "Nome do ambiente (ex.: homolog, preprod, production)."
  type        = string
}

variable "project_id" {
  description = "ID do projeto GCP que será criado para o serviço."
  type        = string
}

variable "project_name" {
  description = "Nome amigável exibido no console (opcional)."
  type        = string
  default     = null
}

variable "project_labels" {
  description = "Rótulos adicionais aplicados ao projeto."
  type        = map(string)
  default     = {}
}

variable "project_services" {
  description = "APIs que devem ser habilitadas no projeto."
  type        = list(string)
  default = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "servicemanagement.googleapis.com",
    "serviceusage.googleapis.com",
    "storage.googleapis.com"
  ]
}

variable "billing_account_id" {
  description = "ID da conta de faturamento (formato 000000-000000-000000)."
  type        = string
}

variable "folder_id" {
  description = "Folder pai onde o projeto será criado (ex.: folders/123456789)."
  type        = string
}

variable "bucket_name" {
  description = "Nome global do bucket GCS que hospedará o site estático."
  type        = string
}

variable "bucket_location" {
  description = "Localização do bucket (ex.: US, EU, us-central1)."
  type        = string
  default     = "US"
}

variable "bucket_storage_class" {
  description = "Classe de armazenamento para o bucket."
  type        = string
  default     = "STANDARD"
}

variable "bucket_force_destroy" {
  description = "Remove o bucket mesmo contendo objetos."
  type        = bool
  default     = false
}

variable "bucket_enable_public_access" {
  description = "Concede leitura pública aos objetos do bucket."
  type        = bool
  default     = true
}

variable "bucket_enable_versioning" {
  description = "Ativa versionamento dos objetos."
  type        = bool
  default     = true
}

variable "bucket_website_main_page" {
  description = "Página principal do site estático."
  type        = string
  default     = "index.html"
}

variable "bucket_website_error_page" {
  description = "Página de erro do site estático."
  type        = string
  default     = "index.html"
}

variable "bucket_log_bucket" {
  description = "Bucket alvo para logs de acesso (opcional)."
  type        = string
  default     = null
}

variable "bucket_log_prefix" {
  description = "Prefixo dos objetos de log."
  type        = string
  default     = null
}

variable "bucket_labels" {
  description = "Rótulos extras aplicados ao bucket."
  type        = map(string)
  default     = {}
}

variable "additional_bucket_viewers" {
  description = "Lista de membros IAM com acesso leitura aos objetos."
  type        = list(string)
  default     = []
}

variable "cdn_name" {
  description = "Nome base utilizado no load balancer (default: bucket_name)."
  type        = string
  default     = null
}

variable "cdn_hostnames" {
  description = "Hostnames atendidos pelo load balancer."
  type        = list(string)

  validation {
    condition     = length(var.cdn_hostnames) > 0
    error_message = "Informe ao menos um hostname completo para expor o load balancer."
  }
}

variable "cdn_enable_http_redirect" {
  description = "Se verdadeiro, listener HTTP redireciona para HTTPS."
  type        = bool
  default     = false
}

variable "cdn_enable_http_backend" {
  description = "Se verdadeiro, listener HTTP serve conteúdo diretamente."
  type        = bool
  default     = true
}

variable "cdn_enable_https" {
  description = "Controla a criação do listener HTTPS."
  type        = bool
  default     = false
}

variable "cdn_use_managed_ssl_certificate" {
  description = "Quando HTTPS ativo, define se o certificado será gerenciado pelo Google."
  type        = bool
  default     = false
}

variable "cdn_existing_ssl_certificate_name" {
  description = "Nome do certificado SSL já existente (quando não gerenciado)."
  type        = string
  default     = null
}

variable "cdn_enable_logging" {
  description = "Ativa logging do Cloud CDN."
  type        = bool
  default     = true
}

variable "cdn_log_sample_rate" {
  description = "Taxa de amostragem para logs (0.0 - 1.0)."
  type        = number
  default     = 1.0
}

variable "cdn_cache_default_ttl" {
  description = "TTL padrão de cache em segundos."
  type        = number
  default     = 3600
}

variable "cdn_cache_max_ttl" {
  description = "TTL máximo de cache em segundos."
  type        = number
  default     = 86400
}

variable "cdn_cache_negative_ttl" {
  description = "TTL para respostas negativas (404/500)."
  type        = number
  default     = 300
}
