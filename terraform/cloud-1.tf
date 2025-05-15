resource "digitalocean_droplet" "cloud-1" {
  count = var.droplet_count

  image = "ubuntu-20-04-x64"
  name = "cloud-1"
  size = "s-1vcpu-1gb"
  region = "ams3"
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
  ipv6 = false
  tags = ["cloud-1"]

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
}

resource "null_resource" "ansible_inventory" {
  depends_on = [ digitalocean_droplet.cloud-1 ]
  triggers = {
    ipv4_addresses = join(",", [for i in digitalocean_droplet.cloud-1 : i.ipv4_address])
  }
  provisioner "local-exec" {
    interpreter = ["python", "-c"]
    command = <<-EOF
      ips = "${self.triggers.ipv4_addresses}".split(',')
      with open('/opt/app/terraform/hosts.dat', 'w') as f:
        for _, ip in enumerate(ips):
          f.write(f"{ip}\n")
    EOF
  }
}
