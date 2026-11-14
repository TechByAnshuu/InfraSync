terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_network" "lab" {
  name = "lab-net"
}

resource "docker_image" "nginx" {
  name = "nginx:stable"
}

resource "docker_image" "haproxy" {
  name = "haproxy:lts"
}

resource "docker_container" "backend" {
  for_each = var.backends
  name     = each.key
  image    = docker_image.nginx.image_id

  networks_advanced {
    name = docker_network.lab.name
  }

  ports {
    internal = 80
    external = each.value.port
  }

  upload {
    file    = "/usr/share/nginx/html/index.html"
    content = templatefile("${path.module}/web.html.tpl", {
      name  = each.key
      color = each.value.color
    })
  }
}

resource "docker_container" "haproxy" {
  name  = "haproxy"
  image = docker_image.haproxy.image_id

  networks_advanced {
    name = docker_network.lab.name
  }

  ports {
    internal = 80
    external = 8080
  }

  ports {
    internal = 8404
    external = 8404
  }

  upload {
    file    = "/usr/local/etc/haproxy/haproxy.cfg"
    content = file("${path.module}/haproxy.cfg")
  }

  depends_on = [docker_container.backend]
}
