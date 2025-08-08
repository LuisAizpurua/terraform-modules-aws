data "aws_vpc" "default"{
  default = true
}

resource "aws_security_group" "sec_group_ssh" {
  description = "allow ssh"
  vpc_id = data.aws_vpc.default.id
  name = "web-ssh"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"  
    cidr_blocks = ["190.140.22.70/32"] // if you are window, use in the terminal this command to get your public IP: (Invoke-WebRequest ifconfig.me/ip).Content
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "web-ssh"
  }
}

resource "aws_security_group" "sec_group_http" {
  description = "allow http"
  vpc_id = data.aws_vpc.default.id
  name = "web-http"

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2-example" {
  ami = data.aws_ami.amzlinux2.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.sec_group_http.id, aws_security_group.sec_group_ssh.id]
  key_name = aws_key_pair.deployer.key_name

  user_data = file("${path.module}/app1-install.sh")
  tags = {
    Name = var.name_tag
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

# locals {
#   id_public = "id-${aws_instance.ec2-example.public_ip}"
# }