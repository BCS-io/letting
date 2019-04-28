# Usage
# https://www.terraform.io/docs/providers/hcloud/index.html
#
# create
#
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
#
# terraform workspace new development
# terraform workspace new test
# terraform workspace select development
# terraform workspace list

variable "hcloud_token" {}

module "hetzner_api" {
  source = "../modules/hetzner"
  hcloud_token = "${var.hcloud_token}"

  # image
  # ubuntu-18.04 / debian-9 / snapshot id
  image = "ubuntu-18.04"

  # server_name
  # danna / papa etc
  server_name = "${lookup(var.server_name_by_workspace,
                          terraform.workspace)}"

  server_type = "cx21"
}

output "public_ip4" {
  value = "${module.hetzner_api.public_ip4}"
}