variable "location" {
  type = string
  description = "location"
}
variable "keyvault_name" {
  type = string
  description = "keyvault name"
}
variable "rg_name" {
  type = string
  description = "resource group name"
}
variable "tenant_id" {
  type = string
  description = "tenant id"
}
variable "object_id" {
  type = string
  description = "assign policy object id"
}
variable "sku_name" {
  type = string
  description = "sku name"
}
variable "purge_protect" {
  type = bool
  description = "purge_protection_enabled"
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
