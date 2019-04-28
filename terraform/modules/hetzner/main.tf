# Usage
# https://www.terraform.io/docs/providers/hcloud/index.html
#
# create
#
# (optional) TF_VAR_hcloud_token=YOUR_SECRET_TOKEN - hardcoded
# terraform init   - download the provider specific binary (hetzner in this case)
# terraform plan
# terraform apply  - outputs the execution plan about what t is going to change
# terraform show   - current state
#
# Use
# root@$(terraform output public_ip4)
#
# clean up
# terraform destroy

# Provider of the resource
provider "hcloud" {
  token =  "${var.hcloud_token}"
  version = "~> 1.9"
}

#  Main ssh key
data "hcloud_ssh_key" "operator" {
  # richard@skye
  fingerprint = "ae:cc:8a:1b:df:47:fc:d6:5c:04:70:f0:03:9d:39:b6"
}

# Resource required
# image: ubuntu-18.04 / debian-9
#
#        Type            Name
resource "hcloud_server" "web_server" {
  name        = "${var.server_name}"
  image       = "${var.image}"
  location    = "nbg1"        # nbg1, fsn1 or hel1
  server_type = "${var.server_type}"
  ssh_keys    = ["${data.hcloud_ssh_key.operator.id}"]
}

output "public_ip4" {
  value = "${hcloud_server.web_server.ipv4_address}"
}
