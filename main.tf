data "proxmox_virtual_environment_nodes" "datacenter" {}

resource "proxmox_virtual_environment_storage_pbs" "pxb1" {
  id        = "pxb1"
  nodes     = data.proxmox_virtual_environment_nodes.datacenter.names
  server    = "fd00::250"
  datastore = "back-pbs-root"

  username    = var.auth.users[1]
  password    = var.auth.passwords[1]
  fingerprint = "e5:40:8a:64:17:86:58:48:db:86:c4:94:b9:7a:40:1b:0f:3c:06:03:3d:a0:aa:a5:57:40:9e:20:6c:1b:ae:20"

  content = ["backup"]

  generate_encryption_key = true

  disable = false
}
