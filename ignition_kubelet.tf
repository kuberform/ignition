data "ignition_config" "ignition_kubelet" {
  files = [
    "${data.ignition_file.ca_root.id}",
    "${data.ignition_file.ca_etcd.id}",
    "${data.ignition_file.ca_etcd_chain.id}",
    "${data.ignition_file.etcd_client_cert.id}",
    "${data.ignition_file.etcd_client_key.id}",
    "${data.ignition_file.ca_kubernetes.id}",
    "${data.ignition_file.ca_kubernetes_chain.id}",
    "${data.ignition_file.kubernetes_client_cert.id}",
    "${data.ignition_file.kubernetes_client_key.id}",
    "${data.ignition_file.ca_kubelet.id}",
    "${data.ignition_file.ca_kubelet_chain.id}",
    "${data.ignition_file.kubelet_server_cert.id}",
    "${data.ignition_file.kubelet_server_key.id}",
    "${data.ignition_file.kubelet_client_cert.id}",
    "${data.ignition_file.kubelet_client_key.id}",
  ]
}

output "ignition-controller" {
  value = "${data.ignition_config.ignition_kubelet.rendered}"
}
