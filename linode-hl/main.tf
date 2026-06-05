locals {
  pmm_label   = "${var.instance_label}-${random_id.suffix.hex}"
  mysql_label = "pmm-mysql-hl-${random_id.suffix.hex}"
  pg_label    = "pmm-postgres-hl-${random_id.suffix.hex}"
  mongo_label = "pmm-mongo-hl-${random_id.suffix.hex}"

  pmm_admin_password = coalesce(var.pmm_admin_password, random_password.pmm_admin.result)
  mysql_password     = coalesce(var.mysql_password, random_password.mysql.result)
  postgres_password  = coalesce(var.postgres_password, random_password.postgres.result)
  mongo_password     = coalesce(var.mongo_password, random_password.mongo.result)
}

resource "random_id" "suffix" {
  byte_length = 3
}

resource "random_password" "pmm_admin" {
  length      = 16
  special     = false
  upper       = true
  lower       = true
  numeric     = true
  min_lower   = 4
  min_upper   = 4
  min_numeric = 4
}

resource "random_password" "mysql" {
  length      = 16
  special     = false
  upper       = true
  lower       = true
  numeric     = true
  min_lower   = 4
  min_upper   = 4
  min_numeric = 4
}

resource "random_password" "postgres" {
  length      = 16
  special     = false
  upper       = true
  lower       = true
  numeric     = true
  min_lower   = 4
  min_upper   = 4
  min_numeric = 4
}

resource "random_password" "mongo" {
  length      = 16
  special     = false
  upper       = true
  lower       = true
  numeric     = true
  min_lower   = 4
  min_upper   = 4
  min_numeric = 4
}

data "linode_firewall" "pmm" {
  id = var.firewall_id
}

module "pmm_server" {
  source = "./modules/linode-vm"

  label          = local.pmm_label
  region         = var.region
  instance_type  = var.pmm_instance_type
  image          = var.image
  ssh_public_key = var.ssh_public_key
  firewall_id    = data.linode_firewall.pmm.id
  tags           = ["pmm-test"]

  user_data = templatefile("${path.module}/cloud-init/pmm-server.yml.tftpl", {
    pmm_docker_image   = var.pmm_docker_image
    pmm_admin_password = local.pmm_admin_password
  })
}

module "mysql" {
  source = "./modules/linode-vm"
  count  = var.mysql_count

  label          = "${local.mysql_label}-${count.index}"
  region         = var.region
  instance_type  = var.instance_type
  image          = var.image
  ssh_public_key = var.ssh_public_key
  firewall_id    = data.linode_firewall.pmm.id
  tags           = ["pmm-test", "mysql"]

  user_data = templatefile("${path.module}/cloud-init/mysql.yml.tftpl", {
    pmm_server_host    = module.pmm_server.public_ip
    pmm_admin_password = local.pmm_admin_password
    pmm_client_image   = var.pmm_client_image
    pmm_clients_per_db = var.pmm_clients_per_db
    metrics_mode       = var.metrics_mode
    mysql_image        = var.mysql_image
    mysql_password     = local.mysql_password
    instance_label     = "${local.mysql_label}-${count.index}"
  })
}

module "postgres" {
  source = "./modules/linode-vm"
  count  = var.postgres_count

  label          = "${local.pg_label}-${count.index}"
  region         = var.region
  instance_type  = var.instance_type
  image          = var.image
  ssh_public_key = var.ssh_public_key
  firewall_id    = data.linode_firewall.pmm.id
  tags           = ["pmm-test", "postgres"]

  user_data = templatefile("${path.module}/cloud-init/postgres.yml.tftpl", {
    pmm_server_host    = module.pmm_server.public_ip
    pmm_admin_password = local.pmm_admin_password
    pmm_client_image   = var.pmm_client_image
    pmm_clients_per_db = var.pmm_clients_per_db
    metrics_mode       = var.metrics_mode
    postgres_image     = var.postgres_image
    postgres_password  = local.postgres_password
    instance_label     = "${local.pg_label}-${count.index}"
  })
}

module "mongo" {
  source = "./modules/linode-vm"
  count  = var.mongo_count

  label          = "${local.mongo_label}-${count.index}"
  region         = var.region
  instance_type  = var.instance_type
  image          = var.image
  ssh_public_key = var.ssh_public_key
  firewall_id    = data.linode_firewall.pmm.id
  tags           = ["pmm-test", "mongo"]

  user_data = templatefile("${path.module}/cloud-init/mongo.yml.tftpl", {
    pmm_server_host    = module.pmm_server.public_ip
    pmm_admin_password = local.pmm_admin_password
    pmm_client_image   = var.pmm_client_image
    pmm_clients_per_db = var.pmm_clients_per_db
    metrics_mode       = var.metrics_mode
    mongo_image        = var.mongo_image
    mongo_password     = local.mongo_password
    instance_label     = "${local.mongo_label}-${count.index}"

    create_pmm_user_js = indent(6, templatefile("${path.module}/cloud-init/scripts/mongo/create_pmm_user.js.tftpl", {
      mongo_password = local.mongo_password
    }))
    load_generator_js = indent(6, file("${path.module}/cloud-init/scripts/mongo/load-generator.js"))
    mongo_load_gen_sh = indent(6, templatefile("${path.module}/cloud-init/scripts/mongo/mongo-load-gen.sh.tftpl", {
      mongo_password = local.mongo_password
    }))
    check_profiler_sh = indent(6, templatefile("${path.module}/cloud-init/scripts/mongo/check-profiler.sh.tftpl", {
      mongo_password = local.mongo_password
    }))
  })
}
