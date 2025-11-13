# Estrutura principal
organization_id     = "419602604664"
billing_account_id  = "01DA36-FF7E31-5EE738"
region              = "us-central1"
environment         = "homolog"
folder_display_name = "homolog"

# Serviços controlados neste ambiente
services = {
  kardume = {
    project_id           = "klubi-kardume-hml"
    bucket_name          = "klubi-kardume-hml"
    bucket_force_destroy = true
    bucket_labels = {
      squad       = "front-end"
      application = "kardume"
    }
    cdn_hostnames    = ["kardume-hml.theklubi.com"]
    cdn_name         = "klubi-kardume-hml"
    cdn_enable_https = false
  }

  compraplanejada = {
    project_id           = "klubi-compraplanejada-hml"
    bucket_name          = "klubi-compraplanejada-hml"
    bucket_force_destroy = true
    bucket_labels = {
      squad       = "front-end"
      application = "compraplanejada"
    }
    cdn_hostnames    = ["compraplanejada-hml.theklubi.com"]
    cdn_name         = "klubi-compraplanejada-hml"
    cdn_enable_https = false
  }

  app = {
    project_id           = "klubi-application-hml"
    bucket_name          = "klubi-application-hml"
    bucket_force_destroy = true
    project_name         = "Application"
    bucket_labels = {
      squad       = "front-end"
      application = "app"
    }
    cdn_hostnames    = ["app-hml.theklubi.com"]
    cdn_name         = "klubi-application-hml"
    cdn_enable_https = false
  }

  simule = {
    project_id           = "klubi-simule-hml"
    bucket_name          = "klubi-simule-hml"
    bucket_force_destroy = true
    bucket_labels = {
      squad       = "front-end"
      application = "simule"
    }
    cdn_hostnames    = ["simule-hml.theklubi.com"]
    cdn_name         = "klubi-simule-hml"
    cdn_enable_https = false
  }
}
