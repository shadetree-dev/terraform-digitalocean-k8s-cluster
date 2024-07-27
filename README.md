# terraform-digital-ocean-k8s-cluster
### v1.0.0
DigitalOcean Managed Kubernetes deployment via Terraform

# Overview
This Terraform project is used to create a new VPC and managed Kubernetes cluster in [DigitalOcean](https://www.digitalocean.com/).

It is a minimal cluster that by default deploys a single node without autoscaling enabled. It also assumes the auto-created firewall is sufficient, but you should consider adding a [digitalocean_firewall](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/firewall) resource configuration for your purposes if you are allowing more complex access patterns.

# Setup
Make sure that you provide the tokens/secrets required for DigitalOcean API access. If you plan to use `Spaces` for your `backend` configuration, make sure to include the Spaces API configuration, as well.

**Example:**
```bash
export TF_VAR_do_token="<YOUR TOKEN>"
export TF_VAR_spaces_key="<YOUR SPACES API KEY>"
export TF_VAR_spaces_secret="<YOUR SPACES API SECRET>"
```

## `backend.tf`
This project `backend.tf` is provided as an example of how to manage your state in [DigitalOcean Spaces](https://www.digitalocean.com/products/spaces), replace the `bucket` and `region`/`endpoint` with your own.

## `Makefile`
The `Makefile` included is intended to simplify the usage of `terraform <command>` operations for `init`, `plan`, `apply`, and `destroy`. This is mainly included as a convention so that running Terraform commands will be the same locally or if you include them in a pipeline.

You need to set your `TF_VAR_name` first. Then you should be able to `init` and `plan`.

**Example:**
```bash
export TF_VAR_name="shadetree-dev-cluster01"
# init stage
make init                                   
Formatting Terraform files...
Initializing Terraform...
Initializing the backend...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.
Initializing provider plugins...
- Reusing previous version of digitalocean/digitalocean from the dependency lock file
- Reusing previous version of hashicorp/helm from the dependency lock file
- Using previously-installed digitalocean/digitalocean v2.39.2

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
terraform workspace select -or-create shadetree-dev-cluster01

# plan stage
make plan
Formatting Terraform files...
Creating Terraform plan...
terraform plan -out=tfplan 
data.digitalocean_kubernetes_versions.default[0]: Reading...
data.digitalocean_kubernetes_versions.default[0]: Read complete after 1s [id=terraform-20240727200142132200000001]

Terraform used the selected providers to generate the following execution plan. Resource
actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # digitalocean_kubernetes_cluster.cluster will be created
  + resource "digitalocean_kubernetes_cluster" "cluster" {
      + auto_upgrade                     = true
      + cluster_subnet                   = (known after apply)
      + created_at                       = (known after apply)
      + destroy_all_associated_resources = false
      + endpoint                         = (known after apply)
      + ha                               = false
      + id                               = (known after apply)
      + ipv4_address                     = (known after apply)
      + kube_config                      = (sensitive value)
      + name                             = "shadetree-dev-cluster01"
      + region                           = "sfo3"
      + registry_integration             = false
      + service_subnet                   = (known after apply)
      + status                           = (known after apply)
      + surge_upgrade                    = true
      + tags                             = [
          + "shadetree-dev",
        ]
      + updated_at                       = (known after apply)
      + urn                              = (known after apply)
      + version                          = "1.30.2-do.0"
      + vpc_uuid                         = (known after apply)

      + maintenance_policy {
          + day        = (known after apply)
          + duration   = (known after apply)
          + start_time = (known after apply)
        }

      + node_pool {
          + actual_node_count = (known after apply)
          + auto_scale        = false
          + id                = (known after apply)
          + name              = "default"
          + node_count        = 1
          + nodes             = (known after apply)
          + size              = "s-1vcpu-2gb"
        }
    }

  # digitalocean_vpc.vpc[0] will be created
  + resource "digitalocean_vpc" "vpc" {
      + created_at  = (known after apply)
      + default     = (known after apply)
      + description = "VPC used for shadetree.dev resources"
      + id          = (known after apply)
      + ip_range    = "10.192.0.0/20"
      + name        = "shadetree-dev-vpc-sfo3"
      + region      = "sfo3"
      + urn         = (known after apply)

      + timeouts {
          + delete = "3m"
        }
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + kubeconfig = "Make sure to run `doctl kubernetes cluster kubeconfig save <cluster>` to update your local kubeconfig"

────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"
```

Then you can just run `make apply` and deploy the resources.

# Known Issues
If you plan to destroy your resources via `make destroy` or `terraform destroy`, you may encounter issues such as below:
```bash
digitalocean_vpc.vpc[0]: Destroying... [id=81b66dd2-e019-4082-9349-4c2f28665f2a]
╷
│ Error: Error deleting VPC: DELETE https://api.digitalocean.com/v2/vpcs/81b66dd2-e019-4082-9349-4c2f28665f2a: 409 (request "002fddeb-b1c1-4d55-a3d8-accdf80d3e45") Can not delete VPC with members
│ 
│ 
╵
```

Even with the `timeouts{}` block configured, you may have issues where there is a delay in resources like `droplets` being destroyed. You can implement workarounds like in [this GitHub issue comment](https://github.com/digitalocean/terraform-provider-digitalocean/issues/488#issuecomment-821825905) to mitigate this, or simply retry after a short period. Note that if you do this, you should replace the `null_resource`, which is deprecated in Terraform `v1.8+`, with [terraform_data](https://developer.hashicorp.com/terraform/language/resources/terraform-data) resources.

# Terraform Details
This information was generated using terraform-docs. You can install this per the instructions provided in its respective project repository, and then generate a table like below using:

```bash
terraform-docs markdown table . | pbcopy
```

(the pbcopy command is specific to MacOS and used to copy to clipboard; your command may vary)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | >= 2.39 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.14 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | 2.39.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [digitalocean_kubernetes_cluster.cluster](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/kubernetes_cluster) | resource |
| [digitalocean_vpc.vpc](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/vpc) | resource |
| [digitalocean_kubernetes_versions.default](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/data-sources/kubernetes_versions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_scale"></a> [auto\_scale](#input\_auto\_scale) | Boolean flag for whether the cluster should be autoscaling | `bool` | `false` | no |
| <a name="input_do_token"></a> [do\_token](#input\_do\_token) | The DigitalOcean access token for managing Terraform resources | `string` | `""` | no |
| <a name="input_k8s_version"></a> [k8s\_version](#input\_k8s\_version) | The Kubernetes version to deploy, which can be shown via `doctl kubernetes options versions` | `string` | `""` | no |
| <a name="input_maintenance_config"></a> [maintenance\_config](#input\_maintenance\_config) | The dates/times to configure maintenance for minor version auto upgrade | `map(any)` | <pre>{<br>  "day": "wednesday",<br>  "enabled": true,<br>  "time": "04:00"<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | The base resource name you want to assign to resources | `string` | `""` | no |
| <a name="input_node_pool_config"></a> [node\_pool\_config](#input\_node\_pool\_config) | The string corresponding to Kubernetes node size for DigitalOcean nodes | `map(any)` | <pre>{<br>  "auto_scale": false,<br>  "max_nodes": null,<br>  "min_nodes": null,<br>  "name": "default",<br>  "node_count": 1,<br>  "size": "s-1vcpu-2gb"<br>}</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | The DigitalOcean region to deploy resources to | `string` | `"sfo3"` | no |
| <a name="input_spaces_key"></a> [spaces\_key](#input\_spaces\_key) | The DigitalOcean spaces access key id | `string` | `""` | no |
| <a name="input_spaces_secret"></a> [spaces\_secret](#input\_spaces\_secret) | The DigitalOcean spaces secret access key | `string` | `""` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | The CIDR block to use for VPC | `string` | `"10.192.0.0/20"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The existing VPC ID if you don't want to create a new one | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kubeconfig"></a> [kubeconfig](#output\_kubeconfig) | What you need to do to update your kubeconfig locally |
