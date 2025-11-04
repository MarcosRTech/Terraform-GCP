# Identificacao do projeto e provedor Google Cloud
project_id = "seu-projeto-gcp"
region     = "us-central1"

# Configuracoes do bucket estatico
bucket_name      = "kardume.theklubi.com"
bucket_location  = "US"
storage_class    = "STANDARD"
force_destroy    = false
website_main_page = "index.html"
website_error_page = "404.html"
enable_public_access = true
bucket_labels = {
  environment = "homolog"
  squad       = "front-end"
}

# Configuracoes de DNS
dns_project_id   = null
dns_managed_zone = "theklubi-com"
dns_ttl          = 300
