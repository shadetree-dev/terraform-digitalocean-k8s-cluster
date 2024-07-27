data "digitalocean_kubernetes_versions" "default" {
  count          = var.k8s_version != "" ? 0 : 1
  version_prefix = "1.30."
}