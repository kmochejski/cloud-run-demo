variable dev_project {
  type = string
}

variable limit_hosts {
  type = list(string)
  default = []
}

variable managed_ssl_certificate_domains {
  type = list(string)
  default = [
    "api.dev.in.kontomatik.com",
    "ml.dev.in.kontomatik.com",
    "signin.dev.in.kontomatik.com"
  ]
}