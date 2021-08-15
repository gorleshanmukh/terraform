output "dbpassword" {
  value = azurerm_key_vault_secret.dbpassword
  description = "dbpassword"
}
output "dbusername" {
  value = azurerm_key_vault_secret.dbusername
  description = "dbusername"
}
output "dbserverurl" {
  value = azurerm_key_vault_secret.dbserverurl
  description = "dbserverurl"
}