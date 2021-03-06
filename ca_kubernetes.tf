resource "tls_private_key" "ca_kubernetes" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "ca_kubernetes" {
  key_algorithm   = "${tls_private_key.ca_kubernetes.algorithm}"
  private_key_pem = "${tls_private_key.ca_kubernetes.private_key_pem}"

  subject {
    common_name         = "Audios Cloud - Kubernetes ${data.aws_region.current.name}"
    organization        = "Audios Ventures, Inc"
    organizational_unit = "Department of Infrastructure"

    street_address = [
      "24 4th Street",
      "Suite #1007",
    ]

    locality    = "Troy"
    province    = "NY"
    country     = "US"
    postal_code = "12180"
  }
}

resource "tls_locally_signed_cert" "ca_kubernetes" {
  ca_key_algorithm   = "${var.ca_root_algo}"
  ca_cert_pem        = "${var.ca_root_cert}"
  ca_private_key_pem = "${var.ca_root_priv}"
  cert_request_pem   = "${tls_cert_request.ca_kubernetes.cert_request_pem}"

  validity_period_hours = 87600
  early_renewal_hours   = 8760

  is_ca_certificate = true

  allowed_uses = [
    "cert_signing",
    "crl_signing",
  ]
}

data "template_file" "ca_kubernetes_chain" {
  template = "${file("${path.module}/templates/certificate_chain.pem")}"

  vars {
    ROOT_CA         = "${var.ca_root_cert}"
    INTERMEDIATE_CA = "${tls_locally_signed_cert.ca_kubernetes.cert_pem}"
  }
}

data "ignition_file" "ca_kubernetes" {
  path       = "/etc/ssl/certs/ca_kubernetes.crt"
  filesystem = "root"
  mode       = 0644
  uid        = 0
  gid        = 0

  content {
    content = "${tls_locally_signed_cert.ca_kubernetes.cert_pem}"
  }
}

data "ignition_file" "ca_kubernetes_chain" {
  path       = "/etc/ssl/certs/ca_kubernetes_chain.crt"
  filesystem = "root"
  mode       = 0644
  uid        = 0
  gid        = 0

  content {
    content = "${data.template_file.ca_kubernetes_chain.rendered}"
  }
}
