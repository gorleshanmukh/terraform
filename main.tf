# Terraform backend config
terraform {
  backend "azurerm" {
    resource_group_name = "main-rg"
    storage_account_name = "gorlesa"
    container_name = "main-container"
    key = "main.tfstate"
  }
}

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

resource "azurerm_app_service" "as" {
  app_service_plan_id = azurerm_app_service_plan.asp.id
  location = azurerm_resource_group.rg.location
  name = var.terraform-app-service-name
  resource_group_name = azurerm_resource_group.rg.name
  app_settings = {
    "dbpassword" = "@Microsoft.KeyVault(VaultName=${var.keyvault-name};SecretName=dbpassword;SecretVersion=${azurerm_key_vault_secret.dbpassword.version})",
    "dbusername" = "user"
  }
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_sql_server" "sqldb" {
  administrator_login = var.terraform-sql-admin-login
  administrator_login_password = var.terraform-sql-admin-password
  location = azurerm_resource_group.rg.location
  name = var.terraform-sql-server-name
  resource_group_name = azurerm_resource_group.rg.name
  version = "12.0"
}

resource "azurerm_sql_database" db {
  location = azurerm_resource_group.rg.location
  name = var.terraform-sql-database-name
  resource_group_name = azurerm_resource_group.rg.name
  server_name = azurerm_sql_server.sqldb.name
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" keyvault {
  location = azurerm_resource_group.rg.location
  name = var.keyvault-name
  resource_group_name = azurerm_resource_group.rg.name
  sku_name = "standard"
  tenant_id = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled = false
  enable_rbac_authorization = true
}

resource "azurerm_role_assignment" "role-secret-officer" {
  role_definition_name = "Key Vault Secrets Officer"
  principal_id = data.azurerm_client_config.current.object_id
  scope = azurerm_key_vault.keyvault.id
}

resource "azurerm_key_vault_secret" "dbpassword" {
  name = "dbpassword"
  value = var.terraform-sql-admin-password
  key_vault_id = azurerm_key_vault.keyvault.id
  depends_on = [azurerm_role_assignment.role-secret-officer]
}

resource "azurerm_role_assignment" "role-secret-user" {
  role_definition_name = "Key Vault Secrets User"
  principal_id = data.azurerm_client_config.current.object_id
  scope = "${azurerm_key_vault.keyvault.id}/secrets/${azurerm_key_vault_secret.dbpassword.name}"
}