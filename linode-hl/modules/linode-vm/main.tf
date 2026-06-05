resource "linode_instance" "vm" {
  label           = var.label
  region          = var.region
  type            = var.instance_type
  image           = var.image
  swap_size       = var.swap_size
  backups_enabled = false

  authorized_keys = [
    var.ssh_public_key
  ]

  metadata {
    user_data = base64encode(var.user_data)
  }

  root_pass = random_password.root.result

  firewall_id = var.firewall_id

  tags = var.tags
}

resource "random_password" "root" {
  length      = 20
  special     = false
  upper       = true
  lower       = true
  numeric     = true
  min_lower   = 5
  min_numeric = 5
  min_upper   = 5
}
