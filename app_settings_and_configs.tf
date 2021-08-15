locals {
  listapp_application_settings = {
    "listapp.db.username" = "@Microsoft.KeyVault(VaultName=${var.keyvault_name};SecretName=listapp-db-username;SecretVersion=${module.db.dbusername.version})",
    "listapp.db.password" = "@Microsoft.KeyVault(VaultName=${var.keyvault_name};SecretName=listapp-db-password;SecretVersion=${module.db.dbpassword.version})",
    "listapp.db.url" = "@Microsoft.KeyVault(VaultName=${var.keyvault_name};SecretName=listapp-db-url;SecretVersion=${module.db.dbserverurl.version})"
  }
  key_permissions = ["get"]
  secret_permissions = ["get","list","set","delete","purge"]
  storage_permissions = ["get"]
  cors = ["*"]
  list_app_server_type = "JAVA|8-jre8"
  list_app_server_kind = "linux"
  list_app_always_on = true
}