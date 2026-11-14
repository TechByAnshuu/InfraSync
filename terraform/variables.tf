variable "backends" {
  type = map(object({
    port  = number
    color = string
  }))
  default = {
    web1 = { port = 8081, color = "#3b82f6" }
    web2 = { port = 8082, color = "#10b981" }
    web3 = { port = 8083, color = "#f59e0b" }
  }
  description = "Backend web server containers with respective host port mappings and brand accent colors"
}
