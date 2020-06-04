locals {
  vars = {
    stream_key = "${random_uuid.streamline.result}"
    hostname   = "${var.hostname}"
    domainname = "${data.aws_route53_zone.selected.name}"
    path       = path.module
  }
}

resource "tls_private_key" "streamline" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "streamline" {
  public_key = tls_private_key.streamline.public_key_openssh
}

resource "aws_spot_instance_request" "streamline" {
  block_duration_minutes = var.instance_spot_block_duration
  spot_price             = var.instance_spot_price
  spot_type              = "one-time"
  wait_for_fulfillment   = true

  ami                         = data.aws_ami.streamline.id
  associate_public_ip_address = true
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.streamline.key_name
  user_data_base64            = base64encode(templatefile("${path.module}/cloud-init/cloud-config.tpl", local.vars))
  security_groups      = [aws_security_group.streamline.name]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "100"
    delete_on_termination = true
  }

  tags = {
    Name = "Streamline Spot Instance ${random_uuid.streamline.result}"
  }

  volume_tags = {
    Name = "Streamline Spot Instance ${random_uuid.streamline.result}"
  }

  count = var.instance_spot ? "1" : "0"
}

resource "aws_instance" "streamline" {
  ami                         = data.aws_ami.streamline.id
  associate_public_ip_address = true
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.streamline.key_name
  user_data_base64            = base64encode(file("${path.module}/cloud-init/cloud-config.tpl"))
  security_groups      = [aws_security_group.streamline.name]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "60"
    delete_on_termination = true
  }

  credit_specification {
    cpu_credits = "standard"
  }

  tags = {
    Name = "Streamline Instance ${random_uuid.streamline.result}"
  }

  volume_tags = {
    Name = "Streamline Instance ${random_uuid.streamline.result}"
  }

  count = var.instance_spot ? "0" : "1"
}

resource "aws_route53_record" "streamline" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.hostname}.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "300"
  records = ["${local.public_ip}"]
}
