variable "vm_name" {
  type        = string
  description = "Name of the VM during build"
  default     = "ubuntu-resolute"
}

variable "template_name" {
  type        = string
  description = "Name for the resulting Proxmox template"
  default     = "template-ubuntu-resolute"
}

variable "px_hostname" {
  type        = string
  description = "Proxmox hostname or IP"
}

variable "px_user" {
  type        = string
  description = "Proxmox username (e.g. root@pam)"
  default     = "root@pam"
}

variable "px_token" {
  type        = string
  description = "Proxmox API token ID and secret (user@realm!tokenid)"
  sensitive   = true
}

variable "vm_user" {
  type        = string
  description = "SSH user for Packer to connect to the VM and to create during autoinstall"
  default     = "ubuntu"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key to add to the created user's authorized_keys during autoinstall"
}

variable "user_password_hash" {
  type        = string
  description = "Hashed password for the created user during autoinstall"
  sensitive   = true
}

variable "ssh_password" {
  type        = string
  description = "SSH password for Packer to connect during the build. Password auth is disabled in the final image."
  sensitive   = true
}
