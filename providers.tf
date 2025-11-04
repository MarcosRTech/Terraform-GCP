variable "project_id" {
  description = "Default GCP project ID used by providers in the root module."
  type        = string
}

variable "region" {
  description = "Default region for regional GCP resources in the root module."
  type        = string
}

variable "dns_project_id" {
  description = "Optional project ID that hosts the Cloud DNS managed zone."
  type        = string
  default     = null
}

locals {
  effective_dns_project_id = coalesce(var.dns_project_id, var.project_id)
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google" {
  alias   = "dns"
  project = local.effective_dns_project_id
}
