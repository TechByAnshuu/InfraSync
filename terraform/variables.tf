variable "controlplane_port" {
  type        = number
  default     = 5000
  description = "Host port for the InfraSync control plane API"
}

variable "backends" {
  type = map(object({
    port      = number
    color     = string
    color_rgb = string
  }))
  default = {
    web1 = { port = 8081, color = "#3b82f6", color_rgb = "59,130,246" }
    web2 = { port = 8082, color = "#10b981", color_rgb = "16,185,129" }
    web3 = { port = 8083, color = "#f59e0b", color_rgb = "245,158,11" }
  }
  description = "Backend web server containers: host port, accent color (hex), and RGB for CSS"
}
