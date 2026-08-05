output "aks_cluster_name" {
  description = "Nom du cluster AKS"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "aks_cluster_endpoint" {
  description = "Endpoint du cluster AKS"
  value       = azurerm_kubernetes_cluster.aks.kube_config[0].host
  sensitive   = true
}

output "acr_login_server" {
  description = "URL de l'Azure Container Registry"
  value       = azurerm_container_registry.acr.login_server
}

output "cosmosdb_endpoint" {
  description = "Endpoint CosmosDB MongoDB"
  value       = azurerm_cosmosdb_account.mongodb.connection_strings[0]
  sensitive   = true
}

output "resource_group_name" {
  description = "Nom du Resource Group"
  value       = azurerm_resource_group.rg.name
}
