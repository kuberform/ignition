data "template_file" "kuberform-controller-manager" {
  template = "${file("${path.module}/services/kuberform-controller-manager.service")}"

  vars {
    IMAGE_SOURCE = "${var.kubernetes["kuberform-controller-manager"]}"
    IMAGE_TAG    = "${var.kubernetes_tag}"
  }
}

data "ignition_systemd_unit" "kuberform-controller-manager" {
  name    = "kuberform-controller-manager.service"
  enabled = true
  content = "${data.template_file.kuberform-controller-manager.rendered}"
}
