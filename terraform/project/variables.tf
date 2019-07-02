variable "server_name_by_workspace" {
  type = "map"

  default = {
    development = "cava.fl-adams.uk"
    staging = "danna.fl-adams.uk"
    production = "eigg.fl-adams.uk"
  }
}