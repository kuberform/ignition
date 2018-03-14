data "template_file" "kube-scheduler" {
  template = "${file("${path.module}/services/kube-scheduler.service")}"

  vars {
    IMAGE_SOURCE = "${var.kubernetes["kube-scheduler"]}"
    IMAGE_TAG    = "${var.kubernetes_tag}"
  }
}

data "ignition_systemd_unit" "kube-scheduler" {
  name    = "kube-scheduler.service"
  enabled = true
  content = "${data.template_file.kube-scheduler.rendered}"
}
