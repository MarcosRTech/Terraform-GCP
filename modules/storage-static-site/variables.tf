variable "project_id" {
  description = "GCP project ID where the storage bucket will be created."
  type        = string
}

variable "bucket_name" {
  description = "Name of the bucket. For static websites with custom domains, this should match the full domain."
  type        = string
}

variable "location" {
  description = "Location for the bucket (for example US, EU, us-central1)."
  type        = string
}

variable "storage_class" {
  description = "Storage class for the bucket."
  type        = string
  default     = "STANDARD"
}

variable "labels" {
  description = "Labels to apply to the bucket."
  type        = map(string)
  default     = {}
}

variable "force_destroy" {
  description = "If true, bucket will be force destroyed (including all objects) when Terraform destroys the resource."
  type        = bool
  default     = false
}

variable "website_main_page" {
  description = "Main page suffix served by the static website."
  type        = string
  default     = "index.html"
}

variable "website_error_page" {
  description = "Error page served by the static website."
  type        = string
  default     = "404.html"
}

variable "enable_public_access" {
  description = "Controls whether objects in the bucket are publicly readable."
  type        = bool
  default     = true
}
