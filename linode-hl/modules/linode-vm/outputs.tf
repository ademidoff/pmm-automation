output "public_ip" {
  value = tolist(linode_instance.vm.ipv4)[0]
}

output "instance_id" {
  value = linode_instance.vm.id
}

output "label" {
  value = linode_instance.vm.label
}

output "root_password" {
  value     = random_password.root.result
  sensitive = true
}
