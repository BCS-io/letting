#  Main ssh key
data "hcloud_ssh_key" "operator" {
  fingerprint = var.ssh_operator_fingerprint
}
