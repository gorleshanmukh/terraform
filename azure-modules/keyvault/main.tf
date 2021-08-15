terraform {}
resource "azurerm_key_vault" keyvault {
  location = var.location
  name = var.keyvault_name
  resource_group_name = var.rg_name
  sku_name = var.sku_name
  tenant_id = var.tenant_id
  purge_protection_enabled = var.purge_protect
}
resource "azurerm_key_vault_access_policy" "user" {
  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id = var.tenant_id
  object_id = var.object_id
  key_permissions = var.key_permissions
  secret_permissions = var.secret_permissions
  storage_permissions = var.storage_permissions
}