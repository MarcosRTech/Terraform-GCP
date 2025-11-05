resource "google_storage_bucket" "this" {
  name     = var.bucket_name
  project  = var.project_id
  location = var.location

  storage_class               = var.storage_class
  force_destroy               = var.force_destroy
  uniform_bucket_level_access = true
  public_access_prevention    = var.enable_public_access ? "inherited" : "enforced"

  labels = var.labels

  versioning {
    enabled = var.enable_versioning
  }

  dynamic "logging" {
    for_each = var.log_bucket == null ? [] : [var.log_bucket]
    content {
      log_bucket        = logging.value
      log_object_prefix = coalesce(var.log_object_prefix, "access-logs/")
    }
  }

  website {
    main_page_suffix = var.website_main_page
    not_found_page   = var.website_error_page
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      num_newer_versions = 10
    }
  }
}

resource "google_storage_bucket_iam_binding" "public_read" {
  count = var.enable_public_access ? 1 : 0

  bucket  = google_storage_bucket.this.name
  role    = "roles/storage.objectViewer"
  members = ["allUsers"]
}

resource "google_storage_bucket_iam_member" "object_viewers" {
  for_each = toset(var.object_viewers)

  bucket = google_storage_bucket.this.name
  role   = "roles/storage.objectViewer"
  member = each.value
}
