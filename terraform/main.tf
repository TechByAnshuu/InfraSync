terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# ── Shared Network ──────────────────────────────────────────────────────────
resource "docker_network" "lab" {
  name = "lab-net"
}

# ── Images ──────────────────────────────────────────────────────────────────
resource "docker_image" "nginx" {
  name = "nginx:stable"
}

resource "docker_image" "haproxy" {
  name = "haproxy:lts"
}

resource "docker_image" "redis" {
  name = "redis:7-alpine"
}

# controlplane image is built locally from ./controlplane/Dockerfile
resource "docker_image" "controlplane" {
  name = "infrasync-controlplane:latest"
  build {
    context = "${path.module}/../controlplane"
  }
}

# ── Redis (Shared State Store) ───────────────────────────────────────────────
resource "docker_container" "redis" {
  name  = "redis"
  image = docker_image.redis.image_id

  networks_advanced {
    name = docker_network.lab.name
  }

  # Persist Redis data across container restarts
  volumes {
    volume_name    = docker_volume.redis_data.name
    container_path = "/data"
  }

  restart = "unless-stopped"
}

resource "docker_volume" "redis_data" {
  name = "infrasync-redis-data"
}

# ── Control Plane API ────────────────────────────────────────────────────────
resource "docker_container" "controlplane" {
  name  = "controlplane"
  image = docker_image.controlplane.image_id

  networks_advanced {
    name = docker_network.lab.name
  }

  ports {
    internal = 5000
    external = 5000
  }

  # Mount Docker socket so Flask can manage sibling containers
  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }

  env = ["REDIS_HOST=redis"]

  depends_on = [docker_container.redis]
  restart    = "unless-stopped"
}

# ── Backend Web Servers ──────────────────────────────────────────────────────
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
    file = "/usr/share/nginx/html/index.html"
    content = templatefile("${path.module}/web.html.tpl", {
      name              = each.key
      color             = each.value.color
      color_rgb         = each.value.color_rgb
      port              = each.value.port
      controlplane_port = var.controlplane_port
    })
  }

  depends_on = [docker_container.controlplane]
}

# ── HAProxy Load Balancer ────────────────────────────────────────────────────
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

# ── Prometheus (Metrics Scraper) ─────────────────────────────────────────────
resource "docker_image" "prometheus" {
  name = "prom/prometheus:latest"
}

resource "docker_container" "prometheus" {
  name  = "prometheus"
  image = docker_image.prometheus.image_id

  networks_advanced {
    name = docker_network.lab.name
  }

  ports {
    internal = 9090
    external = 9090
  }

  upload {
    file    = "/etc/prometheus/prometheus.yml"
    content = file("${path.module}/../monitoring/prometheus.yml")
  }

  depends_on = [docker_container.controlplane]
  restart    = "unless-stopped"
}

# ── Grafana (Observability Dashboards) ───────────────────────────────────────
resource "docker_image" "grafana" {
  name = "grafana/grafana:latest"
}

resource "docker_container" "grafana" {
  name  = "grafana"
  image = docker_image.grafana.image_id

  networks_advanced {
    name = docker_network.lab.name
  }

  ports {
    internal = 3000
    external = 3000
  }

  env = [
    "GF_SECURITY_ADMIN_USER=admin",
    "GF_SECURITY_ADMIN_PASSWORD=admin",
    "GF_AUTH_ANONYMOUS_ENABLED=true",
    "GF_AUTH_ANONYMOUS_ORG_ROLE=Viewer"
  ]

  upload {
    file    = "/etc/grafana/provisioning/datasources/prometheus.yml"
    content = file("${path.module}/../monitoring/grafana-datasource.yml")
  }

  depends_on = [docker_container.prometheus]
  restart    = "unless-stopped"
}
