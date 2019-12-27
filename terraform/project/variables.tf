
variable "hcloud_token" {
}

variable "ssh_operator_fingerprint" {}

variable "server" {
  type = map(string)
}

variable "server_name_by_workspace" {
  type = map(string)
}
