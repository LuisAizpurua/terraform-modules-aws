# output "vpc_id" {
#   value = module.module1.vpc_id
# }

# output "ec2_public_ip" {
#   value = module.module1.ec2_public_ip
# }

# output "ec2_public_dns" {
#   value = module.module1.ec2_public_dns
# }

# output "ssh_connection_command" {
#   value = module.module1.ssh_connection_command //phrase: mute04
# }

output "type_instance_output_1" {
  value = module.module2.available_list
}

output "type_instance_output_2" {
  value = module.module2.available_map
}

output "type_instance_output_3" {
  value = module.module2.available_map_2
}