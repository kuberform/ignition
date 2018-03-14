resource "tls_private_key" "server_kubelet" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "server_kubelet" {
  key_algorithm   = "${tls_private_key.server_kubelet.algorithm}"
  private_key_pem = "${tls_private_key.server_kubelet.private_key_pem}"

  subject {
    common_name         = "*.${data.aws_region.current.name}.k8s.audios.cloud"
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

resource "tls_locally_signed_cert" "server_kubelet" {
  ca_key_algorithm   = "${var.ca_root_algo}"
  ca_cert_pem        = "${var.ca_root_cert}"
  ca_private_key_pem = "${var.ca_root_priv}"
  cert_request_pem   = "${tls_cert_request.server_kubelet.cert_request_pem}"

  validity_period_hours = 87600
  early_renewal_hours   = 8760

  allowed_uses = [
    "server_auth",
  ]
}

resource "tls_private_key" "client_kubelet" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "client_kubelet" {
  key_algorithm   = "${tls_private_key.client_kubelet.algorithm}"
  private_key_pem = "${tls_private_key.client_kubelet.private_key_pem}"

  subject {
    common_name         = "*.${data.aws_region.current.name}.k8s.audios.cloud"
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

resource "tls_locally_signed_cert" "client_kubelet" {
  ca_key_algorithm   = "${var.ca_root_algo}"
  ca_cert_pem        = "${var.ca_root_cert}"
  ca_private_key_pem = "${var.ca_root_priv}"
  cert_request_pem   = "${tls_cert_request.client_kubelet.cert_request_pem}"

  validity_period_hours = 87600
  early_renewal_hours   = 8760

  allowed_uses = [
    "client_auth",
  ]
}

data "ignition_file" "kubelet_server_cert" {
  path       = "/etc/ssl/certs/kubelet_server.pem"
  filesystem = "root"
  mode       = 0644
  uid        = 0
  gid        = 0

  content {
    content = "${tls_locally_signed_cert.server_kubelet.cert_pem}"
  }
}

data "ignition_file" "kubelet_server_key" {
  path       = "/etc/ssl/private/kubelet_server.pem"
  filesystem = "root"
  mode       = 0644
  uid        = 0
  gid        = 0

  content {
    content = "${tls_private_key.server_kubelet.private_key_pem}"
  }
}

data "ignition_file" "kubelet_client_cert" {
  path       = "/etc/ssl/certs/kubelet_client.pem"
  filesystem = "root"
  mode       = 0644
  uid        = 0
  gid        = 0

  content {
    content = "${tls_locally_signed_cert.client_kubelet.cert_pem}"
  }
}

data "ignition_file" "kubelet_client_key" {
  path       = "/etc/ssl/private/kubelet_client.pem"
  filesystem = "root"
  mode       = 0644
  uid        = 0
  gid        = 0

  content {
    content = "${tls_private_key.client_kubelet.private_key_pem}"
  }
}
