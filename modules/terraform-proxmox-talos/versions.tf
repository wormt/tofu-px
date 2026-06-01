terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.97.1"
    }
    talos = {
      source = "siderolabs/talos"
      version = ">= 0.10.1"
    }
  }
}

provider "proxmox" {
  endpoint = var.env.pve_endpoint
  insecure = true
}
