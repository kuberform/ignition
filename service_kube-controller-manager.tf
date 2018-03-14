data "template_file" "kube-controller-manager" {
  template = "${file("${path.module}/services/kube-controller-manager.service")}"

  vars {
    IMAGE_SOURCE = "${var.kubernetes["kube-controller-manager"]}"
    IMAGE_TAG    = "${var.kubernetes_tag}"
  }
}

data "ignition_systemd_unit" "kube-controller-manager" {
  name    = "kube-controller-manager.service"
  enabled = true
  content = "${data.template_file.kube-controller-manager.rendered}"
}
