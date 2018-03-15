data "template_file" "kuberform-apiserver" {
  template = "${file("${path.module}/services/kuberform-apiserver.service")}"

  vars {
    IMAGE_SOURCE = "${var.kubernetes["kuberform-apiserver"]}"
    IMAGE_TAG    = "${var.kubernetes_tag}"
  }
}

data "ignition_systemd_unit" "kuberform-apiserver" {
  name    = "kuberform-apiserver.service"
  enabled = true
  content = "${data.template_file.kuberform-apiserver.rendered}"
}
