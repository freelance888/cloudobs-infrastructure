output "nodes_ips" {
  value = ["${hcloud_server.stream_node.*.ipv4_address}"]
}
