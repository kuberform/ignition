data "template_file" "kube-apiserver" {
  template = "${file("${path.module}/services/kube-apiserver.service")}"

  vars {
    IMAGE_SOURCE = "${var.kubernetes["kube-apiserver"]}"
    IMAGE_TAG    = "${var.kubernetes_tag}"
  }
}

data "ignition_systemd_unit" "kube-apiserver" {
  name    = "kube-apiserver.service"
  enabled = true
  content = "${data.template_file.kube-apiserver.rendered}"
}
