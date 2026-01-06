terraform {
  backend "azurerm" {
    resource_group_name  = "fastapiapp-dev-rg"
    storage_account_name = "fastapiappwestus2dev"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}