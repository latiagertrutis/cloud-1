terraform {
    required_providers {      
        docker = {
            source = "kreuzwerker/docker"
            version = "3.0.2"
        }
    }
}

provider "docker" {
    host = "unix:///var/run/docker.sock"
}

resource "docker_image" "debian" {
    name = "debian:bookworm-slim"
}

resource "docker_container" "foo" {
    image = docker_image.debian.image_id
    name = "foo"
    entrypoint = ["sleep", "infinity"]
}