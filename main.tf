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

resource "azurerm_resource_group" "rg-test-gorle" {
  name     = "rg-hello-azure"
  location = "eastus"
}