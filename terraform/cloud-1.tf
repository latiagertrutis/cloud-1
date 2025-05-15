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
      bootstrap_hosts_block = ''
      inventory_hosts_block = ''
      for i, ip in enumerate(ips):
        bootstrap_hosts_block += f"""
            droplet_{i}:
              ansible_host: {ip}

        """
        inventory_hosts_block += f"""
            droplet_{i}:
              ansible_host: {ip}
        """

      with open('/opt/app/inventory/bootstrap.yml', 'w') as f:
        f.write(f"""
        remote:
          hosts:
        {bootstrap_hosts_block}
          vars:
            ansible_user: root
            ansible_ssh_private_key_file: terraform/ssh/terraform_key
        """)
      with open('/opt/app/inventory/inventory.yml', 'w') as f:
        f.write(f"""
        remote:
          hosts:
        {inventory_hosts_block}
          vars:
            ansible_user: fumon
            ansible_ssh_private_key_file: terraform/ssh/terraform_key
        """)
    EOF
  }
}
