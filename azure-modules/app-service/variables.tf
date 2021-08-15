variable "app_service_plan_name" {
  type = string
  description = "app_service_plan_name"
}
variable "app_service_name" {
  type = string
  description = "app_service_name"
}
variable "kind" {
  type = string
  description = "kind"
}
variable "resource_group_name" {
  type = string
  description = "resource group name"
}
variable "location" {
  type = string
  description = "location"
}
variable "app_settings" {
  type = any
  description = "app_settings"
}
variable "key_permissions" {
  type = list(string)
  description = "key_permissions"
}
variable "secret_permissions" {
  type = list(string)
  description = "secret_permissions"
}
variable "storage_permissions" {
  type = list(string)
  description = "storage_permissions"
}
variable "keyvault_id" {
  type = string
  description = "keyvault_id"
}
variable "tenant_id" {
  type = string
  description = "tenant id"
}
variable "server_type" {
  type = string
  description = "server_type"
}
variable "cors" {
  type = list(string)
  description = "cors allowed origins"
}
variable "always_on" {
  type = bool
  description = "always_on"
}
