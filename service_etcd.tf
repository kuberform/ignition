variable "etcd_image" {
  type        = "string"
  description = "Source of the etcd Docker image to use."
}

variable "etcd_tag" {
  type        = "string"
  description = "Source of the etcd Docker tag to use."
}

variable "etcd_srv" {
  type        = "string"
  description = "The hostname that contains srv records for ETCD bootstrap."
}

data "template_file" "etcd" {
  template = "${file("${path.module}/services/etcd.service")}"

  vars {
    IMAGE_SOURCE  = "${var.etcd_image}"
    IMAGE_TAG     = "${var.etcd_tag}"
    INITIAL_TOKEN = "${md5(var.etcd_srv)}"
    INITIAL_SRV   = "${var.etcd_srv}"
  }
}

data "ignition_systemd_unit" "etcd" {
  name    = "etcd.service"
  enabled = true
  content = "${data.template_file.etcd.rendered}"
}
