
resource "azurerm_virtual_network" "vnet-aulainfra" {
  name                = "vnet"
  location            = azurerm_resource_group.rg-aulainfra.location
  resource_group_name = azurerm_resource_group.rg-aulainfra.name
  address_space       = ["10.0.0.0/16"] 
  
  tags = {
    environment = "Production"
    turma = "FS04"
    faculdade = "Impacta"
    proferror = "Maria"
  }
}

resource "azurerm_subnet" "sub-aulainfra" {
  name                 = "subnet"
  resource_group_name  = azurerm_resource_group.rg-aulainfra.name
  virtual_network_name = azurerm_virtual_network.vnet-aulainfra.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "ip-aulainfra" {
  name                    = "publicip"
  location                = azurerm_resource_group.rg-aulainfra.location
  resource_group_name     = azurerm_resource_group.rg-aulainfra.name
  allocation_method       = "Static"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "test"
  }
}

data "azurerm_public_ip" "ip-aulainfra-data"{
    name = azurerm_public_ip.ip-aulainfra.name
    resource_group_name = azurerm_resource_group.rg-aulainfra.name 
}

resource "azurerm_network_security_group" "nsg-aulainfra" {
  name                = "nsg"
  location            = azurerm_resource_group.rg-aulainfra.location
  resource_group_name = azurerm_resource_group.rg-aulainfra.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Web"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


}
