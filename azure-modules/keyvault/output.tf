output "kv_details" {
  value = azurerm_key_vault.keyvault
  description = "keyvault details"
}
output "kv_userpolicy_details" {
  value = azurerm_key_vault_access_policy.user
  description = "keyvault access uer"
}