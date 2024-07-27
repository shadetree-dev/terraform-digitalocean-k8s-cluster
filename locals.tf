locals {
  # Give pseudo-random name if none is given
  name = var.name != "" ? var.name : "shadetree-dev-cluster-${formatdate("YYYYMMDD", timestamp())}"

  # Tags to apply to all resources
  tags = [
    "shadetree-dev"
  ]
}