output "kubeconfig" {
  description = "What you need to do to update your kubeconfig locally"
  value       = "Make sure to run `doctl kubernetes cluster kubeconfig save <cluster>` to update your local kubeconfig"
}