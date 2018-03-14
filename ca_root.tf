variable "ca_root_algo" {
  type = "string"
}

variable "ca_root_priv" {
  type = "string"
}

variable "ca_root_cert" {
  type = "string"
}

data "ignition_file" "ca_root" {
  path       = "/etc/ssl/certs/ca_root.crt"
  filesystem = "root"
  mode       = 0644
  uid        = 0
  gid        = 0

  content {
    content = "${var.ca_root_cert}"
  }
}
