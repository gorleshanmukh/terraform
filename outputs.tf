output "app_service_name" {
  value = azurerm_app_service.as.name
}

output "app_service_default_hostname" {
  value = "https://${azurerm_app_service.as.default_site_hostname}"
}

output "sql_server_id" {
  value = azurerm_sql_server.sqldb.id
}

output "kv_id" {
  value = azurerm_key_vault.keyvault.id
}
output "vault_uri" {
  value = azurerm_key_vault.keyvault.vault_uri
}