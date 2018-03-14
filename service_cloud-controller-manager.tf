data "template_file" "cloud-controller-manager" {
  template = "${file("${path.module}/services/cloud-controller-manager.service")}"

  vars {
    IMAGE_SOURCE = "${var.kubernetes["cloud-controller-manager"]}"
    IMAGE_TAG    = "${var.kubernetes_tag}"
  }
}

data "ignition_systemd_unit" "cloud-controller-manager" {
  name    = "cloud-controller-manager.service"
  enabled = true
  content = "${data.template_file.cloud-controller-manager.rendered}"
}
