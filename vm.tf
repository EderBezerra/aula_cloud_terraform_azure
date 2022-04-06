
resource "azurerm_network_interface" "nic-aulainfra" {
  name                = "nic"
  location            = azurerm_resource_group.rg-aulainfra.location
  resource_group_name = azurerm_resource_group.rg-aulainfra.name

  ip_configuration {
    name                          = "nic-ip"
    subnet_id                     = azurerm_subnet.sub-aulainfra.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.ip-aulainfra.id
  }
}

resource "azurerm_network_interface_security_group_association" "nic-nsg-aulainfra" {
  network_interface_id      = azurerm_network_interface.nic-aulainfra.id
  network_security_group_id = azurerm_network_security_group.nsg-aulainfra.id
}


resource "azurerm_storage_account" "sa-aulainfra" {
  name                     = "saaulainfra"
  resource_group_name      = azurerm_resource_group.rg-aulainfra.name
  location                 = azurerm_resource_group.rg-aulainfra.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}

resource "azurerm_linux_virtual_machine" "vm-Eder" {
    name                  = "vmEder"
    location              = "brazilsouth"
    resource_group_name   = azurerm_resource_group.rg-aulainfra.name
    network_interface_ids = [azurerm_network_interface.nic-aulainfra.id]
    size                  = "Standard_E2bs_v5"

    os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

   admin_username      = var. user
   admin_password      = var.password 
   disable_password_authentication = false   

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.sa-aulainfra.primary_blob_endpoint
    }   
}
