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
  description = "When true, grants public read access to the bucket."
  type        = bool
  default     = true
}

variable "dns_project_id" {
  description = "Optional project ID that hosts the Cloud DNS managed zone."
  type        = string
  default     = null
}

variable "dns_managed_zone" {
  description = "Cloud DNS managed zone used for kardume.theklubi.com."
  type        = string
}

variable "dns_record_name" {
  description = "Optional override for the DNS record name. Defaults to the bucket name."
  type        = string
  default     = null
}

variable "dns_ttl" {
  description = "TTL for the DNS record."
  type        = number
  default     = 300
}
