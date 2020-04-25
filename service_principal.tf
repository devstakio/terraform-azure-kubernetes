# User Assigned Identities
resource "azurerm_user_assigned_identity" "identity" {
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location

  name = "${data.azurerm_resource_group.resource_group.name}-kubernetes"

  tags = data.azurerm_resource_group.resource_group.tags
}


resource "azuread_application" "application" {
  name = "${data.azurerm_resource_group.resource_group.name}-kube"
}

resource "azuread_service_principal" "service_principal" {
  provider       = azuread
  application_id = azuread_application.application.application_id
}

resource "azuread_service_principal_password" "service_principal_password" {
  provider             = azuread
  service_principal_id = azuread_service_principal.service_principal.id
  value                = "q283497qsadf987fads89fy89324"
  end_date             = "2021-01-01T01:02:03Z"
}

resource "azurerm_role_assignment" "subnet" {
  scope                = data.azurerm_subnet.subnet.id
  role_definition_name = "Network Contributor"
  principal_id         = azuread_service_principal.service_principal.id
}

resource "azurerm_role_assignment" "managed_identity" {
  scope                = azurerm_user_assigned_identity.identity.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azuread_service_principal.service_principal.id
}

// only add this permission if an applciation_gateway_id is set
resource "azurerm_role_assignment" "gateway_contributor" {
  count = coalesce(var.application_gateway_id, 0)

  scope                = var.application_gateway_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.identity.principal_id
}

resource "azurerm_role_assignment" "resource_group_reader" {
  scope                = data.azurerm_resource_group.resource_group.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.identity.principal_id
}


// TODO: remove subscription based permission, and make it a resource group based
data "azurerm_subscription" "current" {}

resource "azurerm_role_assignment" "container_group_role_assignment" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "AcrPull"
  principal_id         = azuread_service_principal.service_principal.id
}