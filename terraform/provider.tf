terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {
  description = "DigitalOcean API token"
  type = string
  sensitive = true
}
variable "pvt_key" {}

provider "digitalocean" {
  token = var.do_token
  http_retry_max = 10
  http_retry_wait_min = 1.0
  http_retry_wait_max = 35.0
}

data "digitalocean_ssh_key" "terraform" {
  name = "cloud-1"
}