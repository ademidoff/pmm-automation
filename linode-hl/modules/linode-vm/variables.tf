variable "label" {
  type = string
}

variable "region" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "image" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "firewall_id" {
  type = number
}

variable "user_data" {
  type        = string
  description = "Raw (unencoded) cloud-init user data. The module base64-encodes it."
}

variable "tags" {
  type    = list(string)
  default = []
}

variable "swap_size" {
  type    = number
  default = 1024
}
