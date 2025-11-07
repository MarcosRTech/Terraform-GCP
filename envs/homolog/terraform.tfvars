# Identificacao do projeto e provedor Google Cloud
project_id = "klubi-homolog"
region     = "us-central1"

# Configuracoes do bucket estatico
bucket_name              = "kardume-homolog"
bucket_location          = "US"
storage_class            = "STANDARD"
force_destroy            = false
website_main_page        = "index.html"
website_error_page       = "index.html"
enable_public_access     = true
enable_bucket_versioning = true
bucket_log_bucket        = null
bucket_log_prefix        = null
bucket_labels = {
  environment = "homolog"
  squad       = "front-end"
}

# Configuracoes do load balancer / Cloud CDN
cdn_hostnames = [
  "kardume.theklubi.com"
]

# Opcional: ajuste caso queira customizar o nome base dos recursos
cdn_name = "kardume-homolog"

# Define se o listener HTTP redireciona todo o trafego para HTTPS
cdn_enable_http_redirect = false

# Expoe o conteudo tambem pela porta 80 sem redirecionar
cdn_enable_http_backend = true

# Certificado SSL: reutiliza o certificado importado "kardume-homolo"
cdn_use_managed_ssl_certificate   = false
cdn_existing_ssl_certificate_name = "kardume-homolo"
