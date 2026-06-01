terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.97.1"
    }
  }
  backend "s3" {
    bucket = var.env.s3_bucket
    key    = "${var.env.environment_name}/terraform.tfstate"
    endpoints = {
      s3 = var.env.s3_endpoint
    }
    skip_credentials_validation = var.env.skip_validation
    skip_region_validation      = var.env.skip_validation
    skip_metadata_api_check     = var.env.skip_validation
    skip_requesting_account_id  = var.env.skip_validation
    skip_s3_checksum            = var.env.skip_validation
  }
}

provider "proxmox" {
  endpoint = "https://[fd00::200]:8006/"
  username = var.auth.users[0]
  password = var.auth.passwords[0]
  insecure = true
}
