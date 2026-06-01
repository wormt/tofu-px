variable "env" {
  type = object({
    environment_name = string
    s3_bucket        = string
    s3_endpoint      = string
    skip_validation  = bool
    pve_endpoint     = string
  })
}

variable "auth" {
  type = object({
    users     = list(string)
    passwords = list(string)
  })
}
