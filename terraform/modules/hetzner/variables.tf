# environment file
# TF_VAR_hcloud_token=YOUR_SECRET_TOKEN - hardcoded
variable "hcloud_token" {}

variable "server_name" {}

variable "image" {}

variable "server_type" {
    default = "cx11"
}
