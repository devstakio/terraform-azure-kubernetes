variable "resource_group_name" {
  description = "The name of the resource group which all resources belong to."
}

variable "network_name" {
  description = "The name of the network to host the K8 hosts"
}

variable "subnet_name" {
  description = "The subnet to host the K8 hosts"
}

variable "dns_prefix" {}

variable "ssh_public_key" {}

variable "application_gateway_id" {
  default = null

  description = "If used, the ID of the gateway. This will set up permissions for kubernetes to alter the app gateway config"
}

variable "workspace_id" {}