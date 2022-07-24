resource "hcloud_ssh_key" "default" {
  name       = "streaming_automation"
  public_key = file("~/.ssh/service.pub")
}

resource "hcloud_server" "stream_node" {
  depends_on  = [hcloud_ssh_key.default]
  count       = var.instances_count
  name        = "stream-node-${count.index}"
  image       = var.image
  server_type = var.instance_type
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.default.id]
  user_data   = file("../../shared/files/userdata.yaml")
}
