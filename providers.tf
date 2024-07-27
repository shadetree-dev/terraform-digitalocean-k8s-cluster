provider "digitalocean" {
  token             = var.do_token
  spaces_access_id  = var.spaces_key
  spaces_secret_key = var.spaces_secret
}