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
    cidr_blocks = ["${var.my_ip}"]
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

module "cp_ec2_zk" {
  source = "./cp-component"
  component = "zk"
  server_sets = "${var.server_sets}"
  ami = data.aws_ami.centos.id
  cluster_sg = [aws_security_group.cluster_sg.id]
  subnet_id              = tolist(data.aws_subnet_ids.all.ids)[0]
  key_name               = "${var.key_name}"
  domain_name               = "${var.domain_name}"
  name_prefix               = "${var.name_prefix}"
  dns_zone = "${var.dns_zone}"
}

module "cp_ec2_bk" {
  source = "./cp-component"
  component = "broker"
  server_sets = "${var.server_sets}"
  ami = data.aws_ami.centos.id
  cluster_sg = [aws_security_group.cluster_sg.id]
  subnet_id              = tolist(data.aws_subnet_ids.all.ids)[0]
  key_name               = "${var.key_name}"
  domain_name               = "${var.domain_name}"
  name_prefix               = "${var.name_prefix}"
  dns_zone = "${var.dns_zone}"
}

module "cp_ec2_co" {
  source = "./cp-component"
  component = "connect"
  server_sets = "${var.server_sets}"
  ami = data.aws_ami.centos.id
  cluster_sg = [aws_security_group.cluster_sg.id]
  subnet_id              = tolist(data.aws_subnet_ids.all.ids)[0]
  key_name               = "${var.key_name}"
  domain_name               = "${var.domain_name}"
  name_prefix               = "${var.name_prefix}"
  dns_zone = "${var.dns_zone}"
}
module "cp_ec2_rp" {
  source = "./cp-component"
  component = "restproxy"
  server_sets = "${var.server_sets}"
  ami = data.aws_ami.centos.id
  cluster_sg = [aws_security_group.cluster_sg.id]
  subnet_id              = tolist(data.aws_subnet_ids.all.ids)[0]
  key_name               = "${var.key_name}"
  domain_name               = "${var.domain_name}"
  name_prefix               = "${var.name_prefix}"
  dns_zone = "${var.dns_zone}"
}
module "cp_ec2_sr" {
  source = "./cp-component"
  component = "schemaregistry"
  server_sets = "${var.server_sets}"
  ami = data.aws_ami.centos.id
  cluster_sg = [aws_security_group.cluster_sg.id]
  subnet_id              = tolist(data.aws_subnet_ids.all.ids)[0]
  key_name               = "${var.key_name}"
  domain_name               = "${var.domain_name}"
  name_prefix               = "${var.name_prefix}"
  dns_zone = "${var.dns_zone}"
}

module "cp_ec2_ks" {
  source = "./cp-component"
  component = "ksql"
  server_sets = "${var.server_sets}"
  ami = data.aws_ami.centos.id
  cluster_sg = [aws_security_group.cluster_sg.id]
  subnet_id              = tolist(data.aws_subnet_ids.all.ids)[0]
  key_name               = "${var.key_name}"
  domain_name               = "${var.domain_name}"
  name_prefix               = "${var.name_prefix}"
  dns_zone = "${var.dns_zone}"
}

module "cp_ec2_cc" {
  source = "./cp-component"
  component = "controlcenter"
  server_sets = "${var.server_sets}"
  ami = data.aws_ami.centos.id
  cluster_sg = [aws_security_group.cluster_sg.id]
  subnet_id              = tolist(data.aws_subnet_ids.all.ids)[0]
  key_name               = "${var.key_name}"
  domain_name               = "${var.domain_name}"
  name_prefix               = "${var.name_prefix}"
  dns_zone = "${var.dns_zone}"
}
