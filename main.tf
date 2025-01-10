# simple terraform to creat CP cluster within AWS, software provisioning to be done via cp-ansible
# data "http" "myip" {
#   url = "http://ipv4.icanhazip.com"
# }
data "http" "myip_request" {
  url = "https://ifconfig.co/json"
  request_headers = {
    Accept = "application/json"
  }
}
locals {
  myip = jsondecode(data.http.myip_request.response_body).ip
}
provider "aws" {
#  version = "~> 2.0"
  region  = var.region
  profile = "confluentcsta"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "baseos" {
  owners      = [var.ami.owner]
  most_recent = true
  # name_regex = var.ami.name_regex
  # filter {
  #     name   = "image-id"
  #     values = [var.ami.ami]
  # }
  filter {
      name   = "description"
      values = ["Amazon Linux 2023 AM*"]
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

#data "aws_security_group" "kerberos_sg" {
#  name = "${var.user_name}_pes_sg"
#  vpc_id = data.aws_vpc.default.id
#}
#resource "aws_instance" "ivan_jump" {
#  ami           = "ami-02eac2c0129f6376b"
#  instance_type = "t2.micro"
#}
resource "aws_security_group" "cluster_sg" {
  name        = "${var.name_prefix}_tf_sg"
  description = "SG for ${var.user_name}s clusters"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [format("%s/32",chomp(local.myip))]
    description = "SSH client"
  }

  ingress {
    from_port   = 9091
    to_port     = 9096
    protocol    = "tcp"
    cidr_blocks = [format("%s/32",chomp(local.myip))]
    description = "Broker (SSL) listener"
  }

  ingress {
    from_port   = 9990
    to_port     = 9999
    protocol    = "tcp"
    cidr_blocks = [format("%s/32",chomp(local.myip))]
    description = "JMX port"
  }

  ingress {
    from_port   = 8081
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = [format("%s/32",chomp(local.myip))]
    description = "Schema registry, Connect, KSQL"
  }

  ingress {
    from_port   = 8088
    to_port     = 8088
    protocol    = "tcp"
    cidr_blocks = [format("%s/32",chomp(local.myip))]
    description = "KSQL"
  }
 
  ingress {
    from_port   = 9021
    to_port     = 9021
    protocol    = "tcp"
    cidr_blocks = [format("%s/32",chomp(local.myip))]
    description = "Control Center"
  }

  ingress {
    from_port   = 2181
    to_port     = 2181
    protocol    = "tcp"
    cidr_blocks = [format("%s/32",chomp(local.myip))]
    description = "Zookeeper"
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [format("%s/32",chomp(local.myip))]
    description = "JMX exporter"
  }
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = [format("%s/32",chomp(local.myip))]
    description = "Prometheus"
  }
  ingress {
    from_port   = 8090
    to_port     = 8091
    protocol    = "tcp"
    cidr_blocks = [format("%s/32",chomp(local.myip))]
    description = "MDS"
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
    Owner_Name = var.owner_name
    Owner_Email = var.owner_email
    Owner = var.owner_name
    Name  = "${var.name_prefix}_tf_sg"
    cflt_managed_by = "user"
    cflt_managed_id = var.owner_name
  }
}

module "cp_ec2_zk" {
  source = "./cp-component"
  component = "zk"
  server_sets = var.server_sets
  ami = data.aws_ami.baseos.id
  cluster_sg = [aws_security_group.cluster_sg.id]
  subnet_id              = tolist(data.aws_subnets.all.ids)[0]
  key_name               = var.key_name
  domain_name            = var.domain_name
  name_prefix            = var.name_prefix
  user_name              = var.user_name
  owner_name             = var.owner_name
  owner_email            = var.owner_email
  dns_zone               = var.dns_zone
}

module "cp_ec2_bk" {
  source = "./cp-component"
  component = "broker"
  server_sets = var.server_sets
  ami = data.aws_ami.baseos.id
  cluster_sg = [aws_security_group.cluster_sg.id]
  subnet_id              = tolist(data.aws_subnets.all.ids)[0]
  key_name               = var.key_name
  domain_name            = var.domain_name
  name_prefix            = var.name_prefix
  user_name              = var.user_name
  owner_name             = var.owner_name
  owner_email            = var.owner_email
  dns_zone               = var.dns_zone
}

module "cp_ec2_co" {
  source = "./cp-component"
  component = "connect"
  server_sets = var.server_sets
  ami = data.aws_ami.baseos.id
  cluster_sg = [aws_security_group.cluster_sg.id]
  subnet_id              = tolist(data.aws_subnets.all.ids)[0]
  key_name               = var.key_name
  domain_name            = var.domain_name
  name_prefix            = var.name_prefix
  user_name              = var.user_name
  owner_name             = var.owner_name
  owner_email            = var.owner_email
  dns_zone               = var.dns_zone
}
module "cp_ec2_rp" {
  source = "./cp-component"
  component = "restproxy"
  server_sets = var.server_sets
  ami = data.aws_ami.baseos.id
  cluster_sg = [aws_security_group.cluster_sg.id]
  subnet_id              = tolist(data.aws_subnets.all.ids)[0]
  key_name               = var.key_name
  domain_name            = var.domain_name
  name_prefix            = var.name_prefix
  user_name              = var.user_name
  owner_name             = var.owner_name
  owner_email            = var.owner_email
  dns_zone               = var.dns_zone
}
module "cp_ec2_sr" {
  source = "./cp-component"
  component = "schemaregistry"
  server_sets = var.server_sets
  ami = data.aws_ami.baseos.id
  cluster_sg = [aws_security_group.cluster_sg.id]
  subnet_id              = tolist(data.aws_subnets.all.ids)[0]
  key_name               = var.key_name
  domain_name            = var.domain_name
  name_prefix            = var.name_prefix
  user_name              = var.user_name
  owner_name             = var.owner_name
  owner_email            = var.owner_email
  dns_zone               = var.dns_zone
}

module "cp_ec2_ks" {
  source = "./cp-component"
  component = "ksql"
  server_sets = var.server_sets
  ami = data.aws_ami.baseos.id
  cluster_sg = [aws_security_group.cluster_sg.id]
  subnet_id              = tolist(data.aws_subnets.all.ids)[0]
  key_name               = var.key_name
  domain_name            = var.domain_name
  name_prefix            = var.name_prefix
  user_name              = var.user_name
  owner_name             = var.owner_name
  owner_email            = var.owner_email
  dns_zone               = var.dns_zone
}

module "cp_ec2_cc" {
  source = "./cp-component"
  component = "controlcenter"
  server_sets = var.server_sets
  ami = data.aws_ami.baseos.id
  cluster_sg = [aws_security_group.cluster_sg.id]
  subnet_id              = tolist(data.aws_subnets.all.ids)[0]
  key_name               = var.key_name
  domain_name            = var.domain_name
  name_prefix            = var.name_prefix
  user_name              = var.user_name
  owner_name             = var.owner_name
  owner_email            = var.owner_email
  dns_zone               = var.dns_zone
}



module "cp_ec2_kafka_controller" {
  source = "./cp-component"
  component = "kafka_controller"
  server_sets = var.server_sets
  ami = data.aws_ami.baseos.id
  cluster_sg = [aws_security_group.cluster_sg.id]
  subnet_id              = tolist(data.aws_subnets.all.ids)[0]
  key_name               = var.key_name
  domain_name            = var.domain_name
  name_prefix            = var.name_prefix
  user_name              = var.user_name
  owner_name             = var.owner_name
  owner_email            = var.owner_email
  dns_zone               = var.dns_zone
}
