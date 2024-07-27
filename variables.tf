variable "do_token" {
  description = "The DigitalOcean access token for managing Terraform resources"
  type        = string
  default     = ""
}

variable "spaces_key" {
  description = "The DigitalOcean spaces access key id"
  type        = string
  default     = ""
}

variable "spaces_secret" {
  description = "The DigitalOcean spaces secret access key"
  type        = string
  default     = ""
}

variable "k8s_version" {
  description = "The Kubernetes version to deploy, which can be shown via `doctl kubernetes options versions`"
  type        = string
  default     = ""
}

variable "name" {
  description = "The base resource name you want to assign to resources"
  type        = string
  default     = ""
}

variable "region" {
  description = "The DigitalOcean region to deploy resources to"
  type        = string
  default     = "sfo3"
}

variable "vpc_cidr" {
  description = "The CIDR block to use for VPC"
  type        = string
  default     = "10.192.0.0/20"
}

variable "vpc_id" {
  description = "The existing VPC ID if you don't want to create a new one"
  type        = string
  default     = null
}

variable "auto_scale" {
  description = "Boolean flag for whether the cluster should be autoscaling"
  type        = bool
  default     = false
}

variable "node_pool_config" {
  description = "The string corresponding to Kubernetes node size for DigitalOcean nodes"
  type        = map(any)
  default = {
    name       = "default"
    size       = "s-1vcpu-2gb"
    auto_scale = false
    node_count = 1
    min_nodes  = null
    max_nodes  = null
  }
}

variable "maintenance_config" {
  description = "The dates/times to configure maintenance for minor version auto upgrade"
  type        = map(any)
  default = {
    enabled = true
    day     = "wednesday"
    time    = "04:00"
  }
}