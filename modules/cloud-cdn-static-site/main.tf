locals {
  sanitized_name = substr(replace(lower(var.name), "/[^a-z0-9-]/", "-"), 0, 40)
  host_rules     = [for h in var.hostnames : trim(h, ".")]
  https_enabled  = var.enable_https
  http_listener_mode = (
    var.enable_http_redirect && var.enable_http_backend ? "invalid" :
    var.enable_http_redirect ? "redirect" :
    var.enable_http_backend ? "backend" :
    "disabled"
  )
}

resource "google_compute_backend_bucket" "static_site" {
  project     = var.project_id
  name        = "${local.sanitized_name}-backend"
  bucket_name = var.bucket_name
  enable_cdn  = true
  description = "Backend bucket for Cloud CDN static site ${var.bucket_name}"

  lifecycle {
    precondition {
      condition     = local.http_listener_mode != "invalid"
      error_message = "enable_http_redirect e enable_http_backend nao podem ser verdadeiros ao mesmo tempo neste modulo."
    }

    precondition {
      condition     = local.https_enabled || local.http_listener_mode != "disabled"
      error_message = "Ative HTTPS (enable_https) ou algum listener HTTP (redirect/backend) para expor o bucket."
    }
  }

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
  count   = local.https_enabled && var.use_managed_ssl_certificate ? 1 : 0
  project = var.project_id
  name    = "${local.sanitized_name}-cert"

  managed {
    domains = local.host_rules
  }
}

data "google_compute_ssl_certificate" "existing" {
  count = (
    local.https_enabled &&
    !var.use_managed_ssl_certificate &&
    var.existing_ssl_certificate_name != null
  ) ? 1 : 0
  project = var.project_id
  name    = var.existing_ssl_certificate_name
}

resource "google_compute_target_https_proxy" "static_site" {
  count   = local.https_enabled ? 1 : 0
  project = var.project_id
  name    = "${local.sanitized_name}-https-proxy"

  url_map = google_compute_url_map.https.id
  ssl_certificates = var.use_managed_ssl_certificate ? [
    google_compute_managed_ssl_certificate.static_site[0].self_link
    ] : (
    var.existing_ssl_certificate_name != null ? [
      data.google_compute_ssl_certificate.existing[0].self_link
    ] : []
  )

  lifecycle {
    precondition {
      condition     = !local.https_enabled || var.use_managed_ssl_certificate || var.existing_ssl_certificate_name != null
      error_message = "Quando nao estiver usando certificado gerenciado, informe existing_ssl_certificate_name com o nome do certificado importado."
    }
  }
}

resource "google_compute_global_address" "static_site" {
  project      = var.project_id
  name         = "${local.sanitized_name}-ipv4"
  address_type = "EXTERNAL"
  ip_version   = "IPV4"
}

resource "google_compute_global_forwarding_rule" "https" {
  count                 = local.https_enabled ? 1 : 0
  project               = var.project_id
  name                  = "${local.sanitized_name}-https-fr"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "443"
  target                = google_compute_target_https_proxy.static_site[0].id
  ip_address            = google_compute_global_address.static_site.address
}

resource "google_compute_url_map" "http_redirect" {
  for_each = local.http_listener_mode == "redirect" ? { redirect = true } : {}
  project  = var.project_id
  name     = "${local.sanitized_name}-http-map"

  default_url_redirect {
    https_redirect         = true
    strip_query            = false
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
  }

  lifecycle {
    precondition {
      condition     = var.enable_https
      error_message = "enable_http_redirect exige enable_https=true para onde redirecionar o trafego."
    }
  }
}

resource "google_compute_target_http_proxy" "redirect" {
  for_each = local.http_listener_mode == "redirect" ? { redirect = true } : {}
  project  = var.project_id
  name     = "${local.sanitized_name}-http-proxy"
  url_map  = google_compute_url_map.http_redirect[each.key].id
}

resource "google_compute_global_forwarding_rule" "http_redirect" {
  for_each              = local.http_listener_mode == "redirect" ? { redirect = true } : {}
  project               = var.project_id
  name                  = "${local.sanitized_name}-http-fr"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.redirect[each.key].id
  ip_address            = google_compute_global_address.static_site.address
}

resource "google_compute_target_http_proxy" "backend" {
  for_each = local.http_listener_mode == "backend" ? { backend = true } : {}
  project  = var.project_id
  name     = "${local.sanitized_name}-http-proxy"
  url_map  = google_compute_url_map.https.id
}

resource "google_compute_global_forwarding_rule" "http_backend" {
  for_each              = local.http_listener_mode == "backend" ? { backend = true } : {}
  project               = var.project_id
  name                  = "${local.sanitized_name}-http-fr"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.backend[each.key].id
  ip_address            = google_compute_global_address.static_site.address
}

moved {
  from = google_compute_target_https_proxy.static_site
  to   = google_compute_target_https_proxy.static_site[0]
}

moved {
  from = google_compute_global_forwarding_rule.https
  to   = google_compute_global_forwarding_rule.https[0]
}
