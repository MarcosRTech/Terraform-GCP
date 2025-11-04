resource "google_storage_bucket" "this" {
  name     = var.bucket_name
  project  = var.project_id
  location = var.location

  storage_class               = var.storage_class
  force_destroy               = var.force_destroy
  uniform_bucket_level_access = false
  public_access_prevention    = var.enable_public_access ? "inherited" : "enforced"

  labels = var.labels

  website {
    main_page_suffix = var.website_main_page
    not_found_page   = var.website_error_page
  }
}

resource "google_storage_bucket_iam_binding" "public_read" {
  count = var.enable_public_access ? 1 : 0

  bucket = google_storage_bucket.this.name
  role   = "roles/storage.objectViewer"
  members = [
    "allUsers",
  ]
}
