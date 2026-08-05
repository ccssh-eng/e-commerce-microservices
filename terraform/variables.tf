variable "resource_group_name" {
  description = "Nom du Resource Group Azure"
  type        = string
  default     = "rg-ecommerce-microservices"
}

variable "location" {
  description = "Région Azure"
  type        = string
  default     = "francecentral"
}

variable "environment" {
  description = "Environnement de déploiement"
  type        = string
  default     = "production"
}

variable "cluster_name" {
  description = "Nom du cluster AKS"
  type        = string
  default     = "aks-ecommerce"
}

variable "acr_name" {
  description = "Nom de l'Azure Container Registry"
  type        = string
  default     = "acrecommerce"
}

variable "cosmosdb_name" {
  description = "Nom du compte CosmosDB (MongoDB API)"
  type        = string
  default     = "cosmos-ecommerce"
}

