terraform {
  backend "s3" {
    endpoints = {
      s3 = "https://sfo2.digitaloceanspaces.com"
    }
    bucket                      = "shadetree-dev-terraform"
    region                      = "us-west-1"
    key                         = "terraform.tfstate"
    workspace_key_prefix        = "workspaces/kubernetes"
    skip_requesting_account_id  = true
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    skip_s3_checksum            = true
  }
}