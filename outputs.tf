output "vpc_id" {
  value = module.module1.vpc_id
}

output "ec2_public_ip" {
  value = module.module1.ec2_public_ip
}

output "ec2_public_dns" {
  value = module.module1.ec2_public_dns
}

output "ssh_connection_command" {
  value = module.module1.ssh_connection_command //phrase: mute04
}
