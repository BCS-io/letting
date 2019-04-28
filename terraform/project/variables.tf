variable "server_name_by_workspace" {
  type = "map"

  default = {
    development = "cava.bcs.io"
    staging = "danna.bcs.io"
    production = "eigg.bcs.io"
  }
}