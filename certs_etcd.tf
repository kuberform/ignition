variable "etcd_server_names" {
  type        = "list"
  description = "Hostnames for the ETCD master servers."
  default     = []
}

variable "etcd_server_addrs" {
  type        = "list"
  description = "Addresses for the ETCD master servers."
  default     = []
}

resource "tls_private_key" "server_etcd" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "server_etcd" {
  key_algorithm   = "${tls_private_key.server_etcd.algorithm}"
  private_key_pem = "${tls_private_key.server_etcd.private_key_pem}"

  dns_names    = ["${var.etcd_server_names}"]
  ip_addresses = ["${var.etcd_server_addrs}"]

  subject {
    common_name         = "etcd.${data.aws_region.current.name}.k8s.audios.cloud"
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

resource "tls_locally_signed_cert" "server_etcd" {
  ca_key_algorithm   = "${var.ca_root_algo}"
  ca_cert_pem        = "${var.ca_root_cert}"
  ca_private_key_pem = "${var.ca_root_priv}"
  cert_request_pem   = "${tls_cert_request.server_etcd.cert_request_pem}"

  validity_period_hours = 87600
  early_renewal_hours   = 8760

  allowed_uses = [
    "server_auth",
    "client_auth",
  ]
}

resource "tls_private_key" "client_etcd" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "client_etcd" {
  key_algorithm   = "${tls_private_key.client_etcd.algorithm}"
  private_key_pem = "${tls_private_key.client_etcd.private_key_pem}"

  subject {
    common_name         = "etcd.${data.aws_region.current.name}.k8s.audios.cloud"
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

resource "tls_locally_signed_cert" "client_etcd" {
  ca_key_algorithm   = "${var.ca_root_algo}"
  ca_cert_pem        = "${var.ca_root_cert}"
  ca_private_key_pem = "${var.ca_root_priv}"
  cert_request_pem   = "${tls_cert_request.client_etcd.cert_request_pem}"

  validity_period_hours = 87600
  early_renewal_hours   = 8760

  allowed_uses = [
    "client_auth",
  ]
}

data "ignition_file" "etcd_server_cert" {
  path       = "/etc/ssl/certs/etcd_server.pem"
  filesystem = "root"
  mode       = 0644
  uid        = 0
  gid        = 0

  content {
    content = "${tls_locally_signed_cert.server_etcd.cert_pem}"
  }
}

data "ignition_file" "etcd_server_key" {
  path       = "/etc/ssl/private/etcd_server.pem"
  filesystem = "root"
  mode       = 0644
  uid        = 0
  gid        = 0

  content {
    content = "${tls_private_key.server_etcd.private_key_pem}"
  }
}

data "ignition_file" "etcd_client_cert" {
  path       = "/etc/ssl/certs/etcd_client.pem"
  filesystem = "root"
  mode       = 0644
  uid        = 0
  gid        = 0

  content {
    content = "${tls_locally_signed_cert.client_etcd.cert_pem}"
  }
}

data "ignition_file" "etcd_client_key" {
  path       = "/etc/ssl/private/etcd_client.pem"
  filesystem = "root"
  mode       = 0644
  uid        = 0
  gid        = 0

  content {
    content = "${tls_private_key.client_etcd.private_key_pem}"
  }
}
