output "vnet_id" {
  value       = azurerm_virtual_network.main.id
  description = "The ID of the virtual network"
}

output "subnet_id" {
  value       = azurerm_subnet.main.id
  description = "The ID of the subnet"
}

output "subnet_ids" {
  value       = { for k, v in azurerm_subnet.main : k => v.id }
  description = "Map of subnet name to subnet ID"
}