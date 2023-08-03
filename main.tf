# module "my_resource_group" {
#   source   = "./resource-group" # Path to the module directory or Git repository
#   AppName  = "Oracle"
#   Instance = "001"
# }


# module "my_storage_account" {
#   source               = "./storage-account" # Path to the module directory or Git repository
#   storage_account_name = "mystorageaccount07252023"
#   resource_group_name  = module.my_resource_group.resource_group_name
#   location             = module.my_resource_group.resource_group_location
#   account_kind         = "StorageV2"
#   replication_type     = "LRS"
#   access_tier          = "Standard"

# }
resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "East US"
}


resource "azuread_application" "example" {
  display_name  = "test application"
  # homepage     = "https://www.example.com"
  # reply_urls   = ["https://www.example.com"]
}

resource "azuread_service_principal" "example" {
  application_id = azuread_application.example.application_id
}

resource "azurerm_role_assignment" "example" {
  scope                = azurerm_resource_group.example.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.example.object_id
}

resource "azuread_application_password" "example" {
  application_object_id = azuread_application.example.object_id
}

data "azurerm_client_config" "current" {
  
}

output "client_id" {
  value = azuread_application.example.application_id
}

output "client_secret" {
  value = azuread_application_password.example.value
  
}

output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}


#deploystorage account