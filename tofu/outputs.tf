output "data_proxmox_virtual_environment_nodes" {
  value = {
    names     = data.proxmox_virtual_environment_nodes.datacenter.names
    cpu_count = data.proxmox_virtual_environment_nodes.datacenter.cpu_count
    online    = data.proxmox_virtual_environment_nodes.datacenter.online
  }
}
