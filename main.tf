provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "listapp-tf-rg"
    storage_account_name = "listapptfsa"
    container_name       = "listappterraformstate"
    key                  = "terraform.tfstate"
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  location = var.location
  name = var.resource-group-name
  tags = {
    "environment" : var.environment
  }
}

resource "azurerm_app_service_plan" "asp" {
  name = var.app-service-plan
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku {
    size = "S1"
    tier = "Standard"
  }
}

resource "azurerm_key_vault" keyvault {
  location = azurerm_resource_group.rg.location
  name = var.keyvault-name
  resource_group_name = azurerm_resource_group.rg.name
  sku_name = "standard"
  tenant_id = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled = false
}

resource "azurerm_key_vault_access_policy" "user" {
  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id
  key_permissions = local.key_permissions
  secret_permissions = local.secret_permissions
  storage_permissions = local.storage_permissions
}

resource "azurerm_key_vault_secret" "dbpassword" {
  name = "listapp-db-password"
  value = var.sql-admin-password
  key_vault_id = azurerm_key_vault.keyvault.id
  depends_on = [azurerm_key_vault_access_policy.user]
}

resource "azurerm_app_service" "as" {
  app_service_plan_id = azurerm_app_service_plan.asp.id
  location = azurerm_resource_group.rg.location
  name = var.app-service-name
  resource_group_name = azurerm_resource_group.rg.name
  site_config = {
    always_on        = true
    linux_fx_version = "JAVA|8-jre8"
    min_tls_verion   = "1.2"
  }
  app_settings = local.listapp_application_settings
  identity {
    type = "SystemAssigned"
  }
  depends_on = [azurerm_key_vault_access_policy.user]
}

resource "azurerm_key_vault_access_policy" "myapp" {
  key_vault_id = azurerm_key_vault.keyvault.id
  object_id = azurerm_app_service.as.identity.0.principal_id
  tenant_id = data.azurerm_client_config.current.tenant_id
  key_permissions = local.key_permissions
  secret_permissions = local.secret_permissions
  storage_permissions = local.storage_permissions
  depends_on = [azurerm_key_vault_access_policy.user]
}

resource "azurerm_sql_server" "sqlserver" {
  administrator_login = var.sql-admin-login
  administrator_login_password = var.sql-admin-password
  location = azurerm_resource_group.rg.location
  name = var.sql-server-name
  resource_group_name = azurerm_resource_group.rg.name
  version = "12.0"
}

resource "azurerm_sql_database" db {
  location = azurerm_resource_group.rg.location
  name = var.sql-database-name
  resource_group_name = azurerm_resource_group.rg.name
  server_name = azurerm_sql_server.sqlserver.name
}

resource "azurerm_key_vault_secret" "dbusername" {
  name = "listapp-db-username"
  value = azurerm_sql_server.sqlserver.administrator_login
  key_vault_id = azurerm_key_vault.keyvault.id
  depends_on = [azurerm_key_vault_access_policy.user]
}

resource "azurerm_key_vault_secret" "dbserverurl" {
  name = "listapp-db-url"
  value = "jdbc:sqlserver://${azurerm_sql_server.sqlserver.fully_qualified_domain_name}:1433;database=${azurerm_sql_database.db.name};encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;"
  key_vault_id = azurerm_key_vault.keyvault.id
  depends_on = [azurerm_key_vault_access_policy.user]
}

