locals {
  listapp_application_settings = {
    "dbpassword" = "@Microsoft.KeyVault(VaultName=${var.keyvault-name};SecretName=dbpassword;SecretVersion=${azurerm_key_vault_secret.dbpassword.version})",
    "dbusername" = "user"
  }
  key_permissions = ["get"]
  secret_permissions = ["get","list","set","delete","purge"]
  storage_permissions = ["get"]
}