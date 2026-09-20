output "resource_group_name" {
  value       = azurerm_resource_group.lab.name
  description = "The name of the resource group"
}

output "resource_group_id" {
  value       = azurerm_resource_group.lab.id
  description = "The full Azure resource ID of the resource group"
}