terraform {}
resource "azurerm_app_service_plan" "asp" {
  name = var.app_service_plan_name
  location = var.location
  resource_group_name = var.resource_group_name
  kind = var.kind
  reserved = true
  sku {
    size = "S1"
    tier = "Standard"
  }
}
resource "azurerm_app_service" "as" {
  app_service_plan_id = azurerm_app_service_plan.asp.id
  location = var.location
  name = var.app_service_name
  resource_group_name = var.resource_group_name
  site_config {
    linux_fx_version = var.server_type
    always_on = var.always_on
    cors {
      allowed_origins = var.cors
    }
  }
  app_settings = var.app_settings
  identity {
    type = "SystemAssigned"
  }
}
resource "azurerm_key_vault_access_policy" "myapp" {
  key_vault_id = var.keyvault_id
  object_id = azurerm_app_service.as.identity.0.principal_id
  tenant_id = var.tenant_id
  key_permissions = var.key_permissions
  secret_permissions = var.secret_permissions
  storage_permissions = var.storage_permissions
}