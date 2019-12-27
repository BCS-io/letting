
module "hetzner_api" {
  source       = "../modules/hetzner"
  hcloud_token             = var.hcloud_token
  ssh_operator_fingerprint = var.ssh_operator_fingerprint
  server                   = var.server
  server_name              = var.server_name_by_workspace[terraform.workspace]
}
