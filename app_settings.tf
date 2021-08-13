locals {
  listapp_application_settings = {
    "listapp.db.username" = "@Microsoft.KeyVault(VaultName=${var.keyvault-name};SecretName=listapp-db-username;SecretVersion=${azurerm_key_vault_secret.dbusername.version})",
    "listapp.db.password" = "@Microsoft.KeyVault(VaultName=${var.keyvault-name};SecretName=listapp-db-password;SecretVersion=${azurerm_key_vault_secret.dbpassword.version})",
    "listapp.db.name" = "@Microsoft.KeyVault(VaultName=${var.keyvault-name};SecretName=listapp-db-name;SecretVersion=${azurerm_key_vault_secret.dbname.version})"
    "listapp.db.server" = "@Microsoft.KeyVault(VaultName=${var.keyvault-name};SecretName=listapp-db-server;SecretVersion=${azurerm_key_vault_secret.dbserver.version})"
  }
  key_permissions = ["get"]
  secret_permissions = ["get","list","set","delete","purge"]
  storage_permissions = ["get"]
}