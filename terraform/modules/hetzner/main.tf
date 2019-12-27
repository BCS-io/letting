# Provider of the resource
provider "hcloud" {
  token =  var.hcloud_token
  version = "~> 1.15"
}

# Resource required
#        Type            Name
resource "hcloud_server" "web_server" {
  name        = var.server_name
  image       = var.server.image
  location    = var.server.location
  server_type = var.server.server_type
  ssh_keys    = [data.hcloud_ssh_key.operator.id]
}
