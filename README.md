## Providers

| Name | Version |
|------|---------|
| azuread | n/a |
| azurerm | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| application\_gateway\_id | If used, the ID of the gateway. This will set up permissions for kubernetes to alter the app gateway config | `any` | n/a | yes |
| dns\_prefix | n/a | `any` | n/a | yes |
| network\_name | The name of the network to host the K8 hosts | `any` | n/a | yes |
| resource\_group\_name | The name of the resource group which all resources belong to. | `any` | n/a | yes |
| ssh\_public\_key | n/a | `any` | n/a | yes |
| subnet\_name | The subnet to host the K8 hosts | `any` | n/a | yes |
| workspace\_id | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| client\_certificate | n/a |
| cluster\_name | n/a |
| identity\_client\_id | n/a |
| identity\_resource\_id | n/a |
| kube\_config | n/a |
| node\_resource\_group | n/a |
