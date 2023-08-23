locals {
  tags = {
    cost    = "shared"
    creator = "terraform"
    git     = var.git
  }
}

module "hash" {
  source   = "github.com/champ-oss/terraform-git-hash.git?ref=v1.0.12-fc3bb87"
  path     = "${path.module}/.."
  fallback = ""
}
