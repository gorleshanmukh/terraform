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
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "get",
    ]

    secret_permissions = [
      "get",
      "list",
      "set",
      "delete"
    ]

    storage_permissions = [
      "get",
    ]
  }
}

resource "azurerm_key_vault_secret" "dbpassword" {
  name = "dbpassword"
  value = var.sql-admin-password
  key_vault_id = azurerm_key_vault.keyvault.id
}

resource "azurerm_app_service" "as" {
  app_service_plan_id = azurerm_app_service_plan.asp.id
  location = azurerm_resource_group.rg.location
  name = var.app-service-name
  resource_group_name = azurerm_resource_group.rg.name
  app_settings = {
    "dbpassword" = "@Microsoft.KeyVault(VaultName=${var.keyvault-name};SecretName=dbpassword;SecretVersion=${azurerm_key_vault_secret.dbpassword.version})",
    "dbusername" = "user"
  }
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_key_vault_access_policy" "myapp" {
  key_vault_id = azurerm_key_vault.keyvault.id
  object_id = azurerm_app_service.as.identity.0.principal_id
  tenant_id = data.azurerm_client_config.current.tenant_id
  key_permissions = [
    "get",
  ]

  secret_permissions = [
    "get",
    "list",
    "set",
    "delete"
  ]
  storage_permissions = [
    "get",
  ]
}

resource "azurerm_sql_server" "sqldb" {
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
  server_name = azurerm_sql_server.sqldb.name
}