terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

locals {
  normalized_record_name = format("%s.", trim(var.record_name, "."))
}

resource "google_dns_record_set" "this" {
  name         = local.normalized_record_name
  managed_zone = var.managed_zone
  type         = upper(var.record_type)
  ttl          = var.ttl
  rrdatas      = var.rrdatas
}
