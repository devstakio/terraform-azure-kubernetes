output "client_certificate" {
  value = azurerm_kubernetes_cluster.kubernetes_cluster.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.kubernetes_cluster.kube_config_raw
}

output "node_resource_group" {
  value = azurerm_kubernetes_cluster.kubernetes_cluster.node_resource_group
}

output "identity_resource_id" {
  value = azurerm_user_assigned_identity.identity.id
}

output "identity_client_id" {
  value = azurerm_user_assigned_identity.identity.client_id
}

output "cluster_name" {
  value = azurerm_kubernetes_cluster.kubernetes_cluster.name
}