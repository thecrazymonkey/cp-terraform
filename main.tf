# simple terraform to creat CP cluster within AWS, software provisioning to be done via cp-ansible
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

provider "aws" {
  version = "~> 2.0"
  region  = var.region
  profile = "confluentsa"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_ami" "centos" {
  owners      = ["aws-marketplace"]
  most_recent = true

  filter {
      name   = "product-code"
      values = ["aw0evgkw8e5c1q413zgy5pjce"]
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

data "aws_security_group" "kerberos_sg" {
  name = "${var.user_name}_pes_sg"
  vpc_id = data.aws_vpc.default.id
}
#resource "aws_instance" "ivan_jump" {
#  ami           = "ami-02eac2c0129f6376b"
#  instance_type = "t2.micro"
#}
resource "aws_security_group" "cluster_sg" {
  name        = "${var.user_name}_sg"
  description = "SG for ${var.user_name}s clusters"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [format("%s/32",chomp(data.http.myip.body))]
    description = "SSH client"
  }

  ingress {
    from_port   = 9093
    to_port     = 9093
    protocol    = "tcp"
    cidr_blocks = [format("%s/32",chomp(data.http.myip.body))]
    description = "Broker (SSL) listener"
  }

  ingress {
    from_port   = 9999
    to_port     = 9999
    protocol    = "tcp"
    cidr_blocks = [format("%s/32",chomp(data.http.myip.body))]
    description = "JMX port"
  }

  ingress {
    from_port   = 8081
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = [format("%s/32",chomp(data.http.myip.body))]
    description = "Schema registry, Connect, KSQL"
  }

  ingress {
    from_port   = 8088
    to_port     = 8088
    protocol    = "tcp"
    cidr_blocks = [format("%s/32",chomp(data.http.myip.body))]
    description = "KSQL"
  }
 
  ingress {
    from_port   = 9021
    to_port     = 9021
    protocol    = "tcp"
    cidr_blocks = [format("%s/32",chomp(data.http.myip.body))]
    description = "Control Center"
  }

  ingress {
    from_port   = 2181
    to_port     = 2181
    protocol    = "tcp"
    cidr_blocks = [format("%s/32",chomp(data.http.myip.body))]
    description = "Zookeeper"
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [format("%s/32",chomp(data.http.myip.body))]
    description = "JMX exporter"
  }
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = [format("%s/32",chomp(data.http.myip.body))]
    description = "Prometheus"
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
  tags = {
    Owner = var.user_name
    Name  = "${var.user_name}_sg"
  }
}

module "cp_ec2_zk" {
  source = "./cp-component"
  component = "zk"
  server_sets = var.server_sets
  ami = data.aws_ami.centos.id
  cluster_sg = [aws_security_group.cluster_sg.id,data.aws_security_group.kerberos_sg.id]
  subnet_id              = tolist(data.aws_subnet_ids.all.ids)[0]
  key_name               = var.key_name
  domain_name            = var.domain_name
  name_prefix            = var.name_prefix
  user_name              = var.user_name
  dns_zone = var.dns_zone
}

module "cp_ec2_bk" {
  source = "./cp-component"
  component = "broker"
  server_sets = var.server_sets
  ami = data.aws_ami.centos.id
  cluster_sg = [aws_security_group.cluster_sg.id,data.aws_security_group.kerberos_sg.id]
  subnet_id              = tolist(data.aws_subnet_ids.all.ids)[0]
  key_name               = var.key_name
  domain_name               = var.domain_name
  name_prefix               = var.name_prefix
  user_name              = var.user_name
  dns_zone = var.dns_zone
}

module "cp_ec2_co" {
  source = "./cp-component"
  component = "connect"
  server_sets = var.server_sets
  ami = data.aws_ami.centos.id
  cluster_sg = [aws_security_group.cluster_sg.id,data.aws_security_group.kerberos_sg.id]
  subnet_id              = tolist(data.aws_subnet_ids.all.ids)[0]
  key_name               = var.key_name
  domain_name               = var.domain_name
  name_prefix               = var.name_prefix
  user_name              = var.user_name
  dns_zone = var.dns_zone
}
module "cp_ec2_rp" {
  source = "./cp-component"
  component = "restproxy"
  server_sets = var.server_sets
  ami = data.aws_ami.centos.id
  cluster_sg = [aws_security_group.cluster_sg.id,data.aws_security_group.kerberos_sg.id]
  subnet_id              = tolist(data.aws_subnet_ids.all.ids)[0]
  key_name               = var.key_name
  domain_name               = var.domain_name
  name_prefix               = var.name_prefix
  user_name              = var.user_name
  dns_zone = var.dns_zone
}
module "cp_ec2_sr" {
  source = "./cp-component"
  component = "schemaregistry"
  server_sets = var.server_sets
  ami = data.aws_ami.centos.id
  cluster_sg = [aws_security_group.cluster_sg.id,data.aws_security_group.kerberos_sg.id]
  subnet_id              = tolist(data.aws_subnet_ids.all.ids)[0]
  key_name               = var.key_name
  domain_name               = var.domain_name
  name_prefix               = var.name_prefix
  user_name              = var.user_name
  dns_zone = var.dns_zone
}

module "cp_ec2_ks" {
  source = "./cp-component"
  component = "ksql"
  server_sets = var.server_sets
  ami = data.aws_ami.centos.id
  cluster_sg = [aws_security_group.cluster_sg.id,data.aws_security_group.kerberos_sg.id]
  subnet_id              = tolist(data.aws_subnet_ids.all.ids)[0]
  key_name               = var.key_name
  domain_name               = var.domain_name
  name_prefix               = var.name_prefix
  user_name              = var.user_name
  dns_zone = var.dns_zone
}

module "cp_ec2_cc" {
  source = "./cp-component"
  component = "controlcenter"
  server_sets = var.server_sets
  ami = data.aws_ami.centos.id
  cluster_sg = [aws_security_group.cluster_sg.id,data.aws_security_group.kerberos_sg.id]
  subnet_id              = tolist(data.aws_subnet_ids.all.ids)[0]
  key_name               = var.key_name
  domain_name               = var.domain_name
  name_prefix               = var.name_prefix
  user_name              = var.user_name
  dns_zone = var.dns_zone
}
