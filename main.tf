resource "digitalocean_vpc" "vpc" {
  count       = var.vpc_id != null ? 0 : 1
  name        = "shadetree-dev-vpc-${var.region}"
  description = "VPC used for shadetree.dev resources"
  region      = var.region
  ip_range    = var.vpc_cidr

  timeouts {
    delete = "3m"
  }
}

resource "digitalocean_kubernetes_cluster" "cluster" {
  depends_on = [
    data.digitalocean_kubernetes_versions.default,
    digitalocean_vpc.vpc
  ]
  name         = local.name
  region       = var.region
  auto_upgrade = true
  version      = data.digitalocean_kubernetes_versions.default[0].latest_version
  vpc_uuid     = digitalocean_vpc.vpc[0].id

  maintenance_policy {
    day        = var.maintenance_config.enabled == true ? var.maintenance_config.day : null
    start_time = var.maintenance_config.enabled == true ? var.maintenance_config.start_time : null
  }

  node_pool {
    name       = var.node_pool_config.name
    size       = var.node_pool_config.size
    node_count = var.node_pool_config.node_count
    auto_scale = var.node_pool_config.auto_scale
    min_nodes  = var.node_pool_config.min_nodes
    max_nodes  = var.node_pool_config.max_nodes
  }

  tags = local.tags
}