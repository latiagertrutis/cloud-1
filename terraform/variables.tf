variable "do_token" {
  description = "DigitalOcean API token"
  type = string
  sensitive = true
}
variable "pvt_key" {
    description = "SSH private key file path for droplet connection"
    type = string
}
variable "ssh_key_name" {
    description = "SSH public key name in DigitalOcean"
    type = string
}