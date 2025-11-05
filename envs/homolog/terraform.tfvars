# Identificacao do projeto e provedor Google Cloud
project_id = "klubi-homolog"
region     = "us-central1"

# Configuracoes do bucket estatico
bucket_name              = "kardume-homolog"
bucket_location          = "US"
storage_class            = "STANDARD"
force_destroy            = false
website_main_page        = "index.html"
website_error_page       = "404.html"
enable_public_access     = true
enable_bucket_versioning = true
bucket_log_bucket        = null
bucket_log_prefix        = null
bucket_labels = {
  environment = "homolog"
  squad       = "front-end"
}
