output "pmm_server_ip" {
  value = module.pmm_server.public_ip
}

output "pmm_server_label" {
  value = module.pmm_server.label
}

output "mysql_ips" {
  value = [for m in module.mysql : m.public_ip]
}

output "postgres_ips" {
  value = [for m in module.postgres : m.public_ip]
}

output "mongo_ips" {
  value = [for m in module.mongo : m.public_ip]
}

output "pmm_admin_password" {
  value     = local.pmm_admin_password
  sensitive = true
}

output "mysql_password" {
  value     = local.mysql_password
  sensitive = true
}

output "postgres_password" {
  value     = local.postgres_password
  sensitive = true
}

output "mongo_password" {
  value     = local.mongo_password
  sensitive = true
}
