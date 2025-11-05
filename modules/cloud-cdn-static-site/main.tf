locals {
  sanitized_name = substr(replace(lower(var.name), "/[^a-z0-9-]/", "-"), 0, 40)
  host_rules     = [for h in var.hostnames : trim(h, ".")]
}

resource "google_compute_backend_bucket" "static_site" {
  project     = var.project_id
  name        = "${local.sanitized_name}-backend"
  bucket_name = var.bucket_name
  enable_cdn  = true
  description = "Backend bucket for Cloud CDN static site ${var.bucket_name}"

  cdn_policy {
    cache_mode        = "CACHE_ALL_STATIC"
    default_ttl       = var.cache_default_ttl
    max_ttl           = var.cache_max_ttl
    negative_caching  = true
    serve_while_stale = 86400

    negative_caching_policy {
      code = 404
      ttl  = var.cache_negative_ttl
    }
  }

}

resource "google_compute_url_map" "https" {
  project         = var.project_id
  name            = "${local.sanitized_name}-https-map"
  description     = "URL map for HTTPS traffic to ${var.bucket_name}"
  default_service = google_compute_backend_bucket.static_site.id

  host_rule {
    hosts        = local.host_rules
    path_matcher = "site-paths"
  }

  path_matcher {
    name            = "site-paths"
    default_service = google_compute_backend_bucket.static_site.id

    path_rule {
      paths = ["/"]
      url_redirect {
        https_redirect         = true
        strip_query            = false
        redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
        path_redirect          = "/index.html"
      }
    }
  }
}

resource "google_compute_managed_ssl_certificate" "static_site" {
  project = var.project_id
  name    = "${local.sanitized_name}-cert"

  managed {
    domains = local.host_rules
  }
}

resource "google_compute_target_https_proxy" "static_site" {
  project = var.project_id
  name    = "${local.sanitized_name}-https-proxy"

  url_map = google_compute_url_map.https.id
  ssl_certificates = [
    google_compute_managed_ssl_certificate.static_site.id,
  ]
}

resource "google_compute_global_address" "static_site" {
  project      = var.project_id
  name         = "${local.sanitized_name}-ipv4"
  address_type = "EXTERNAL"
  ip_version   = "IPV4"
}

resource "google_compute_global_forwarding_rule" "https" {
  project               = var.project_id
  name                  = "${local.sanitized_name}-https-fr"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "443"
  target                = google_compute_target_https_proxy.static_site.id
  ip_address            = google_compute_global_address.static_site.address
}

resource "google_compute_url_map" "http_redirect" {
  count   = var.enable_http_redirect ? 1 : 0
  project = var.project_id
  name    = "${local.sanitized_name}-http-map"

  default_url_redirect {
    https_redirect         = true
    strip_query            = false
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
  }
}

resource "google_compute_target_http_proxy" "redirect" {
  count   = var.enable_http_redirect ? 1 : 0
  project = var.project_id
  name    = "${local.sanitized_name}-http-proxy"
  url_map = google_compute_url_map.http_redirect[count.index].id
}

resource "google_compute_global_forwarding_rule" "http" {
  count                 = var.enable_http_redirect ? 1 : 0
  project               = var.project_id
  name                  = "${local.sanitized_name}-http-fr"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.redirect[count.index].id
  ip_address            = google_compute_global_address.static_site.address
}
