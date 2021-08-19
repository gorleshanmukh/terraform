provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "listapp-tf-rg"
    storage_account_name = "listapptfsa"
    container_name       = "listappterraformstate"
    key                  = "listappeastus.tfstate"
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  location = var.location
  name = var.resource_group_name
  tags = {
    "environment" : var.environment
  }
}

module "keyvault" {
  source = "./azure-modules/keyvault"
  keyvault_name = var.keyvault_name
  location = azurerm_resource_group.rg.location
  rg_name = azurerm_resource_group.rg.name
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id
  purge_protect = false
  sku_name = "standard"
  secret_permissions = local.secret_permissions
  key_permissions = local.key_permissions
  storage_permissions = local.storage_permissions
}

module "db" {
  source = "./azure-modules/sql-db"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sql_server_name = var.sql_server_name
  sql_admin_login = var.sql_admin_login
  sql_admin_password = var.sql_admin_password
  sql_database_name = var.sql_database_name
  keyvault_id = module.keyvault.kv_details.id
  depends_on = [module.keyvault.kv_userpolicy_details]
}

module "appservice" {
  source = "./azure-modules/app-service"
  app_service_name = var.app_service_name
  app_service_plan_name = var.app_service_plan
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id = data.azurerm_client_config.current.tenant_id
  kind = local.list_app_server_kind
  keyvault_id =  module.keyvault.kv_details.id
  app_settings = local.listapp_application_settings
  server_type = local.list_app_server_type
  cors = local.cors
  secret_permissions = local.secret_permissions
  key_permissions = local.key_permissions
  storage_permissions = local.storage_permissions
  depends_on = [module.keyvault.kv_userpolicy_details]
  always_on = local.list_app_always_on
}