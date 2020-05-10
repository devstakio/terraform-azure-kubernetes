data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

data "azurerm_subnet" "subnet" {
  resource_group_name = data.azurerm_resource_group.resource_group.name

  name                 = var.subnet_name
  virtual_network_name = var.network_name
}

resource "azurerm_kubernetes_cluster" "kubernetes_cluster" {
  name                = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  //  node_resource_group = data.azurerm_resource_group.resource_group.name
  dns_prefix = var.dns_prefix

  default_node_pool {
    name               = "default"
    availability_zones = []
    node_count         = 1
    //    max_count             = 2
    //    min_count             = 1
    //    enable_auto_scaling   = false
    enable_node_public_ip = false
    node_labels           = data.azurerm_resource_group.resource_group.tags
    tags                  = data.azurerm_resource_group.resource_group.tags
    vm_size               = "Standard_D2_v2"
    vnet_subnet_id        = data.azurerm_subnet.subnet.id
    max_pods              = 30
    os_disk_size_gb       = 100
  }

  service_principal {
    client_id     = azuread_service_principal.service_principal.application_id
    client_secret = azuread_service_principal_password.service_principal_password.value
  }

  // TODO might set to true. Need a VPN connect to the environment first
  private_cluster_enabled = false

  addon_profile {
    aci_connector_linux {
      enabled     = true
      subnet_name = data.azurerm_subnet.subnet.name
    }

    http_application_routing {
      enabled = false
    }

    kube_dashboard {
      enabled = true
    }

    oms_agent {
      enabled                    = var.workspace_id == null ? false : true
      log_analytics_workspace_id = var.workspace_id
    }
  }

  network_profile {
    network_plugin     = "azure"
    service_cidr       = "10.100.0.0/24"
    dns_service_ip     = "10.100.0.10"
    docker_bridge_cidr = "172.17.0.1/24"
  }

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }

  api_server_authorized_ip_ranges = []
  enable_pod_security_policy      = false

  tags = data.azurerm_resource_group.resource_group.tags

  lifecycle {
    ignore_changes = [windows_profile]
  }
}