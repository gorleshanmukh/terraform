variable "environment" {
  type=string
  description = "environment name"
}
variable "resource_group_name" {
  type=string
  description = "resource group name"
}
variable "location" {
  type=string
  description = "location"
}
variable "app_service_plan" {
  type=string
  description="app_service_plan"
}
variable "keyvault_name" {
  type=string
  description="keyvault_name"
}
variable "app_service_name" {
  type=string
  description="app_service_name"
}
variable "sql_server_name" {
  type=string
  description="sql_server_name"
}
variable "sql_admin_login" {
  type=string
  description="sql_admin_login"
}
variable "sql_admin_password" {
  type=string
  description="sql_admin_password"
}
variable "sql_database_name" {
  type=string
  description="sql_database_name"
}