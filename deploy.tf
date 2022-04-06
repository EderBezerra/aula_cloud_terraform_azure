resource "null_resource" "install-weserver" {
   
  connection {
    type="ssh"
    host =  data.azurerm_public_ip.ip-aulainfra-data.ip_address
    user = var.user
    password = var.password
  }

  provisioner "remote-exec" {
  
    inline = [
      "sudo apt update",
       "sudo apt install -y apache2",
    ]
  }
    
    depends_on = [
      azurerm_linux_virtual_machine.vm-Eder
    ]

}


resource "null_resource" "upload-app" {
   
  connection {
    type="ssh"
    host =  data.azurerm_public_ip.ip-aulainfra-data.ip_address
    user = var.user
    password = var.password
  }

  provisioner "file" {
  
  source ="app"
  destination ="/home/adminuser"
   
  }    
    depends_on = [
      azurerm_linux_virtual_machine.vm-Eder
    ]

}

