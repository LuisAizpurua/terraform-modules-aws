output "vpc_id" {
  value = data.aws_vpc.default.id
}

output "ec2_public_ip" {
  value = aws_instance.ec2-example.public_ip
}

output "ec2_public_dns" {
  value = aws_instance.ec2-example.public_dns
}

output "ssh_connection_command" {
  value = "ssh -i ~/.ssh/deployer-key ec2-user@${aws_instance.ec2-example.public_ip}"
}
