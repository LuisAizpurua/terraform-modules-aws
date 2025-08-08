resource "aws_instance" "myec2vm" {
  ami = data.aws_ami.amzlinux2.id
  instance_type = "t2.micro"
  user_data = file("${path.module}/../module1/app1-install.sh")

  for_each = toset(keys({ for az, details in data.aws_ec2_instance_type_offerings.available :
  az => details.instance_types if length(details.instance_types) != 0 }))
  availability_zone = each.key
  tags = {
    Name = "demo-${each.key}"
  }
}

data "aws_ami" "amzlinux2"{
   most_recent = true
   owners = ["amazon"]

   filter {
      name = "name"
      values = ["al2023-ami-*-kernel-6.1-x86_64"]
   }

   filter{
      name = "virtualization-type"
      values = ["hvm"]
   }
   filter {
      name = "root-device-type"
      values = ["ebs"]
   }

   filter {
     name = "architecture"
     values = ["x86_64"]
   }

}

data "aws_availability_zones" "my_azones" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "aws_ec2_instance_type_offerings" "available" {
    for_each = toset(data.aws_availability_zones.my_azones.names)

  filter {
    name   = "instance-type"
    values = ["t2.micro"]
  }
  filter {
    name   = "location"
    values = [each.key]
  }
    location_type = "availability-zone"
}

output "available_list" {
  value = [for i in data.aws_ec2_instance_type_offerings.available: i.instance_types]
}

output "available_map" {
  value = {
    for k,v in data.aws_ec2_instance_type_offerings.available: k => v.instance_types
  }
}

output "available_map_2" {
  value = {
    for k,v in data.aws_ec2_instance_type_offerings.available: k => v.instance_types if length(v.instance_types) != 0 
  }
}

