provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.app_name}-${var.env}-rg"
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.app_name}${var.env}acr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_service_plan" "plan" {
  name                = "${var.app_name}-${var.env}-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "F1"
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                        = "${var.app_name}-${var.env}-kv"
  location                    = var.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
}

resource "azurerm_linux_web_app" "app" {
  name                = "${var.app_name}-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  service_plan_id     = azurerm_service_plan.plan.id


  site_config {
    application_stack {
      docker_image_name   = "${azurerm_container_registry.acr.login_server}/app:latest"
      docker_registry_url = "https://${azurerm_container_registry.acr.login_server}"
    }

    health_check_path = "/health"
    health_check_eviction_time_in_min = 2
    always_on = false
  }

  app_settings = {
    ENVIRONMENT = var.env
    SECRET_VALUE = "@Microsoft.KeyVault(SecretUri=https://fastapiapp-dev-kv.vault.azure.net/secrets/API-SECRET/)"
  }
}