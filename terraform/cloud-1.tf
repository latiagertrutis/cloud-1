resource "digitalocean_droplet" "cloud-1" {
  image = "ubuntu-20-04-x64"
  name = "cloud-1"
  size = "s-1vcpu-1gb"
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
  user_data = <<-EOF
  #!/bin/bash

  apt-get update
  apt-get install -y python3
  EOF
  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "2m"
  }
  provisioner "local-exec" {
    command = "echo ${self.ipv4_address}"
  }
}

output "cloud-1_public_ip" {
  # Testing
  description = "IP of managed droplet resource"
#  value = digitalocean_droplet.ipv4_address
  value = digitalocean_droplet.cloud-1.ipv4_address
}