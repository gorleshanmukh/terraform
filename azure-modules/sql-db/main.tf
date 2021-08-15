terraform {}
resource "azurerm_sql_server" "sqlserver" {
  administrator_login = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
  location = var.location
  name = var.sql_server_name
  resource_group_name = var.resource_group_name
  version = "12.0"
}
resource "azurerm_sql_database" db {
  location = var.location
  name = var.sql_database_name
  resource_group_name = var.resource_group_name
  server_name = azurerm_sql_server.sqlserver.name
}
resource "azurerm_sql_firewall_rule" "example" {
  name                = "azure services"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_sql_server.sqlserver.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}
resource "azurerm_key_vault_secret" "dbpassword" {
  name = "listapp-db-password"
  value = var.sql_admin_password
  key_vault_id = var.keyvault_id
}
resource "azurerm_key_vault_secret" "dbusername" {
  name = "listapp-db-username"
  value = azurerm_sql_server.sqlserver.administrator_login
  key_vault_id = var.keyvault_id
}
resource "azurerm_key_vault_secret" "dbserverurl" {
  name = "listapp-db-url"
  value = "jdbc:sqlserver://${azurerm_sql_server.sqlserver.fully_qualified_domain_name}:1433;database=${azurerm_sql_database.db.name};encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;"
  key_vault_id = var.keyvault_id
}
