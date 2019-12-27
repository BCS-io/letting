# environment file
# TF_VAR_hcloud_token=YOUR_SECRET_TOKEN - hardcoded
variable "hcloud_token" {}

variable "ssh_operator_fingerprint" {}

variable "server" {
  type = map(string)
}

variable "server_name" {}
