data "template_file" "kuberform-scheduler" {
  template = "${file("${path.module}/services/kuberform-scheduler.service")}"

  vars {
    IMAGE_SOURCE = "${var.kubernetes["kuberform-scheduler"]}"
    IMAGE_TAG    = "${var.kubernetes_tag}"
  }
}

data "ignition_systemd_unit" "kuberform-scheduler" {
  name    = "kuberform-scheduler.service"
  enabled = true
  content = "${data.template_file.kuberform-scheduler.rendered}"
}
