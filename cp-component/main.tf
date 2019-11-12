locals {
  component   = var.component
  server_sets = var.server_sets
  zone_id     = var.dns_zone
}
resource "aws_instance" "this" {
  count                  = local.server_sets[local.component]["count"]
  instance_type          = local.server_sets[local.component]["size"]
  monitoring             = false
  associate_public_ip_address = true
  vpc_security_group_ids = var.cluster_sg
  subnet_id              = var.subnet_id
  ami                    = var.ami
  key_name               = var.key_name
# in case you need to overwrite hostname on VM
#  user_data              = "#!/bin/bash\nhostnamectl set-hostname --static ${local.server_sets[local.component]["dns_name"]}${count.index+1}.${var.name_prefix}.${var.domain_name}"
  root_block_device {
      volume_type = "gp2"
      volume_size = local.server_sets[local.component]["volume_size"]
  }
  tags = {
    Name = "${local.server_sets[local.component]["dns_name"]}${count.index+1}.${var.name_prefix}.${var.domain_name}"
    ivan_cluster = "${var.name_prefix}-${local.server_sets[local.component]["dns_name"]}-${count.index+1}"
    Owner = "Ivan"
  }
}

resource "aws_route53_record" "this" {
  zone_id = local.zone_id
  count   = local.server_sets[local.component]["count"]
  name    = "${local.server_sets[local.component]["dns_name"]}${count.index+1}.${var.name_prefix}.${var.domain_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_instance.this[count.index].public_dns]
}