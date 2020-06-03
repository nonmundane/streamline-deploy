data "aws_ami" "streamline" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name = "name"
    # For non LTS latest use "ubuntu/images/hvm-ssd/ubuntu-eoan-19.10-amd64-server-*"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_route53_zone" "selected" {
  name         = "FOO.BAR"
  private_zone = false
}

data "aws_subnet" "streamline" {
  id = "subnet-XXXXXXXX"
}

resource "random_uuid" "streamline" {}
