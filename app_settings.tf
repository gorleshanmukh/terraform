locals {
  site_config = [{
    always_on        = true
    linux_fx_version = "JAVA|8-jre8"
    min_tls_verion   = "1.2"
  }]
  listapp_application_settings = {
    "listapp.db.username" = "@Microsoft.KeyVault(VaultName=${var.keyvault-name};SecretName=listapp-db-username;SecretVersion=${azurerm_key_vault_secret.dbusername.version})",
    "listapp.db.password" = "@Microsoft.KeyVault(VaultName=${var.keyvault-name};SecretName=listapp-db-password;SecretVersion=${azurerm_key_vault_secret.dbpassword.version})",
    "listapp.db.url" = "@Microsoft.KeyVault(VaultName=${var.keyvault-name};SecretName=listapp-db-url;SecretVersion=${azurerm_key_vault_secret.dbserverurl.version})"
  }
  key_permissions = ["get"]
  secret_permissions = ["get","list","set","delete","purge"]
  storage_permissions = ["get"]
}