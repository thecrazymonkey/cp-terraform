# simple terraform to creat CP cluster within AWS, software provisioning to be done via cp-ansible

provider "aws" {
  version = "~> 2.0"
  region  = "${var.region}"
  profile = "confluentsa"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_ami" "centos" {
  owners      = ["679593333241"]
  most_recent = true

  filter {
      name   = "name"
      values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
      name   = "architecture"
      values = ["x86_64"]
  }

  filter {
      name   = "root-device-type"
      values = ["ebs"]
  }
}

#resource "aws_instance" "ivan_jump" {
#  ami           = "ami-02eac2c0129f6376b"
#  instance_type = "t2.micro"
#}
resource "aws_security_group" "cluster_sg" {
  name        = "${var.name_prefix}_sg"
  description = "SG for ${var.name_prefix}s clusters"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["74.96.192.160/32"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2_cluster_zookeeper" {
#  source                 = "terraform-aws-modules/ec2-instance/aws"
#  version                = "~> 2.0"
  count                  = "${var.server_sets["zk"]["count"]}"
  key_name               = "${var.key_name}"
  ami                    = data.aws_ami.centos.id
  instance_type          = "${var.server_sets["zk"]["size"]}"
  monitoring             = false
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.cluster_sg.id]
  subnet_id              = tolist(data.aws_subnet_ids.all.ids)[0]
  root_block_device {
      volume_type = "gp2"
      volume_size = "${var.server_sets["zk"]["volume_size"]}"
  }
  tags = {
    Name = "zk${count.index+1}.${var.name_prefix}.confluent.nerdynick.net"
    ivan_cluster = "${var.name_prefix}-zookeeper-${count.index+1}"
  }
}

resource "aws_route53_record" "rt53zk" {
  zone_id = "${var.dns_zone}"
  count   = "${var.server_sets["zk"]["count"]}"
  name    = "zk${count.index+1}.${var.name_prefix}.confluent.nerdynick.net"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_instance.ec2_cluster_zookeeper[count.index].public_dns}"]
}

resource "aws_instance" "ec2_cluster_broker" {
  associate_public_ip_address = true
  count                  = "${var.server_sets["broker"]["count"]}"
  key_name               = "${var.key_name}"
  ami                    = data.aws_ami.centos.id
  instance_type          = "${var.server_sets["broker"]["size"]}"
  monitoring             = false
  vpc_security_group_ids = [aws_security_group.cluster_sg.id]
  subnet_id              = tolist(data.aws_subnet_ids.all.ids)[0]
  root_block_device {
      volume_type = "gp2"
      volume_size = "${var.server_sets["broker"]["volume_size"]}"
  }
  tags = {
    Name = "kafka${count.index+1}.${var.name_prefix}.confluent.nerdynick.net"
    ivan_cluster = "${var.name_prefix}-broker-${count.index+1}"
  }
}

resource "aws_route53_record" "rt53bk" {
  zone_id = "${var.dns_zone}"
  count   = "${var.server_sets["broker"]["count"]}"
  name    = "kafka${count.index+1}.${var.name_prefix}.confluent.nerdynick.net"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_instance.ec2_cluster_broker[count.index].public_dns}"]
}

resource "aws_instance" "ec2_cluster_connect" {
  associate_public_ip_address = true
  count                  = "${var.server_sets["connect"]["count"]}"
  key_name               = "${var.key_name}"
  ami                    = data.aws_ami.centos.id
  instance_type          = "${var.server_sets["connect"]["size"]}"
  monitoring             = false
  vpc_security_group_ids = [aws_security_group.cluster_sg.id]
  subnet_id              = tolist(data.aws_subnet_ids.all.ids)[0]
  root_block_device {
      volume_type = "gp2"
      volume_size = "${var.server_sets["connect"]["volume_size"]}"
  }
  tags = {
    Name = "connect${count.index+1}.${var.name_prefix}.confluent.nerdynick.net"
    ivan_cluster = "${var.name_prefix}-connect-${count.index+1}"
  }
}

resource "aws_route53_record" "rt53co" {
  zone_id = "${var.dns_zone}"
  count   = "${var.server_sets["connect"]["count"]}"
  name    = "connect${count.index+1}.${var.name_prefix}.confluent.nerdynick.net"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_instance.ec2_cluster_connect[count.index].public_dns}"]
}

resource "aws_instance" "ec2_cluster_schemaregistry" {
  associate_public_ip_address = true
  count                  = "${var.server_sets["schemaregistry"]["count"]}"
  key_name               = "${var.key_name}"
  ami                    = data.aws_ami.centos.id
  instance_type          = "${var.server_sets["schemaregistry"]["size"]}"
  monitoring             = false
  vpc_security_group_ids = [aws_security_group.cluster_sg.id]
  subnet_id              = tolist(data.aws_subnet_ids.all.ids)[0]
  root_block_device {
      volume_type = "gp2"
      volume_size = "${var.server_sets["schemaregistry"]["volume_size"]}"
  }
  tags = {
    Name = "schemaregistry${count.index+1}.${var.name_prefix}.confluent.nerdynick.net"
    ivan_cluster = "${var.name_prefix}-schemaregistry-${count.index+1}"
  }
}

resource "aws_route53_record" "rt53sc" {
  zone_id = "${var.dns_zone}"
  count   = "${var.server_sets["schemaregistry"]["count"]}"
  name    = "schemaregistry${count.index+1}.${var.name_prefix}.confluent.nerdynick.net"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_instance.ec2_cluster_schemaregistry[count.index].public_dns}"]
}

resource "aws_instance" "ec2_cluster_restproxy" {
  associate_public_ip_address = true
  count                  = "${var.server_sets["restproxy"]["count"]}"
  key_name               = "${var.key_name}"
  ami                    = data.aws_ami.centos.id
  instance_type          = "${var.server_sets["restproxy"]["size"]}"
  monitoring             = false
  vpc_security_group_ids = [aws_security_group.cluster_sg.id]
  subnet_id              = tolist(data.aws_subnet_ids.all.ids)[0]
  root_block_device {
      volume_type = "gp2"
      volume_size = "${var.server_sets["restproxy"]["volume_size"]}"
  }
  tags = {
    Name = "restproxy${count.index+1}.${var.name_prefix}.confluent.nerdynick.net"
    ivan_cluster = "${var.name_prefix}-restproxy-${count.index+1}"
  }
}

resource "aws_route53_record" "rt53rp" {
  zone_id = "${var.dns_zone}"
  count   = "${var.server_sets["restproxy"]["count"]}"
  name    = "restproxy${count.index+1}.${var.name_prefix}.confluent.nerdynick.net"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_instance.ec2_cluster_restproxy[count.index].public_dns}"]
}

resource "aws_instance" "ec2_cluster_ksql" {
  associate_public_ip_address = true
  count                  = "${var.server_sets["ksql"]["count"]}"
  key_name               = "${var.key_name}"
  ami                    = data.aws_ami.centos.id
  instance_type          = "${var.server_sets["ksql"]["size"]}"
  monitoring             = false
  vpc_security_group_ids = [aws_security_group.cluster_sg.id]
  subnet_id              = tolist(data.aws_subnet_ids.all.ids)[0]
  root_block_device {
      volume_type = "gp2"
      volume_size = "${var.server_sets["ksql"]["volume_size"]}"
  }
  tags = {
    Name = "ksql${count.index+1}.${var.name_prefix}.confluent.nerdynick.net"
    ivan_cluster = "${var.name_prefix}-ksql-${count.index+1}"
  }
}

resource "aws_route53_record" "rt53ks" {
  zone_id = "${var.dns_zone}"
  count   = "${var.server_sets["ksql"]["count"]}"
  name    = "ksql${count.index+1}.${var.name_prefix}.confluent.nerdynick.net"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_instance.ec2_cluster_ksql[count.index].public_dns}"]
}

resource "aws_instance" "ec2_cluster_controlcenter" {
  associate_public_ip_address = true
  count                  = "${var.server_sets["controlcenter"]["count"]}"
  key_name               = "${var.key_name}"
  ami                    = data.aws_ami.centos.id
  instance_type          = "${var.server_sets["controlcenter"]["size"]}"
  monitoring             = false
  vpc_security_group_ids = [aws_security_group.cluster_sg.id]
  subnet_id              = tolist(data.aws_subnet_ids.all.ids)[0]
  root_block_device {
      volume_type = "gp2"
      volume_size = "${var.server_sets["controlcenter"]["volume_size"]}"
  }
  tags = {
    Name = "controlcenter${count.index+1}.${var.name_prefix}.confluent.nerdynick.net"
    ivan_cluster = "${var.name_prefix}-controlcenter-${count.index+1}"
  }
}

resource "aws_route53_record" "rt53cs" {
  zone_id = "${var.dns_zone}"
  count   = "${var.server_sets["controlcenter"]["count"]}"
  name    = "controlcenter${count.index+1}.${var.name_prefix}.confluent.nerdynick.net"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_instance.ec2_cluster_controlcenter[count.index].public_dns}"]
}
