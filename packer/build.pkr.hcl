packer {
  required_plugins {
    name = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}


source "proxmox-iso" "ubuntu_resolute" {
  vm_name                  = "${var.vm_name}"
  vm_id                    = 120
  proxmox_url              = "https://${var.px_hostname}/api2/json"
  insecure_skip_tls_verify = true
  qemu_agent               = true

  boot_iso {
    iso_url          = "https://releases.ubuntu.com/resolute/ubuntu-26.04-live-server-amd64.iso"
    iso_storage_pool = "local"
    iso_checksum     = "sha256:dec49008a71f6098d0bcfc822021f4d042d5f2db279e4d75bdd981304f1ca5d9"
    unmount          = true
  }

  username = "${var.px_user}"
  token    = "${var.px_token}"

  node        = "px1"

  http_content = {
    "/user-data" = templatefile("http_serve/user-data", {
      ssh_public_key     = var.ssh_public_key
      vm_user            = var.vm_user
      user_password_hash = var.user_password_hash
    })
    "/meta-data" = file("http_serve/meta-data")
    "/network-data" = file("http_serve/network-data")
  }
  http_port_min = 6767
  http_port_max = 6767

  ssh_username           = "${var.vm_user}"
  ssh_password           = var.ssh_password
  ssh_timeout            = "67m"
  ssh_handshake_attempts = 67
  ssh_pty                = true

  template_name        = "${var.template_name}"
  template_description = "Packer generated."

  pool            = "packer"
  memory          = 4096
  cores           = 2
  sockets         = 1
  os              = "l26"
  scsi_controller = "virtio-scsi-pci"

  disks {
    type         = "virtio"
    disk_size    = "20G"
    storage_pool = "local-lvm"
    format       = "raw"
  }

  network_adapters {
    bridge   = "vmbr0"
    model    = "virtio"
    firewall = true
  }

  cloud_init              = true
  cloud_init_storage_pool = "local-lvm"

  boot_command = [
    "<esc><wait>",
    "e<wait>",
    "<down><down><down><end>",
    "<bs><bs><bs><bs><wait>",
    "autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<wait>",
    "<f10><wait>"
  ]
  boot      = "c"
  boot_wait = "5s"


}

build {
  name    = "ubuntu-resolute"
  sources = ["source.proxmox-iso.ubuntu_resolute"]

  provisioner "shell" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
      "sudo rm /etc/ssh/ssh_host_*",
      "sudo truncate -s 0 /etc/machine-id",
      "sudo apt -y autoremove --purge",
      "sudo apt -y clean",
      "sudo apt -y autoclean",
      "sudo systemctl enable qemu-guest-agent",
      "sudo cloud-init clean",
      "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
      "sudo sync"
    ]
  }

  provisioner "file" {
    source      = "files/67_px.cfg"
    destination = "/tmp/67_px.cfg"
  }

  provisioner "shell" {
    inline = [
      "sudo cp /tmp/67_px.cfg /etc/cloud/cloud.cfg.d/67_px.cfg",
      "sudo tee /etc/ssh/sshd_config.d/99-packer-hardening.conf << 'EOF'",
      "PermitRootLogin no",
      "PasswordAuthentication no",
      "EOF"
    ]
  }
}
