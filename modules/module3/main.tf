terraform {
  required_providers{
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_instance" "ec2_aws" {
  ami = "ami-09e6f87a47903347c"
  key_name = aws_key_pair.aws_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.aws_sec.id]
  instance_type = "t2.micro"
  tags = {
    Name = "test_ec2_example"
  }

  provisioner "file" {
    source = "C:/Users/HOME/.aws/test-file.txt"
    destination = "/HOME/ec2-user/test-file.txt"
  }

    connection {
    type        = "ssh"
    user        = "ec2-user"               
    private_key = file("~/.ssh/id_rsa")   
    host        = self.public_ip
  }
}

resource "aws_security_group" "aws_sec" {
  egress = [{
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    description = ""
    self = false
    prefix_list_ids = []
    security_groups = []
    protocol = "-1"
    from_port = 0
    to_port = 0
  }]

  ingress = [{
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    description = ""
    self = false
    prefix_list_ids = []
    security_groups = []
    protocol = "tcp"
    from_port = 22
    to_port = 22

  }]
}


resource "aws_key_pair" "aws_key_pair" {
  key_name = "aws_key"
  public_key = file("~/.ssh/id_rsa.pub")
}


