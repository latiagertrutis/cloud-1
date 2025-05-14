output "cloud-1_public_ip" {
  description = "IPs of managed droplet resource"
  value = digitalocean_droplet.cloud-1[*].ipv4_address
}