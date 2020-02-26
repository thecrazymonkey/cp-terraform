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

#resource "aws_instance" "ivan_jump" {
#  ami           = "ami-02eac2c0129f6376b"
#  instance_type = "t2.micro"
#}
resource "aws_security_group" "cluster_sg" {
  name        = "${var.user_name}_pes_sg"
  description = "SG for ${var.user_name}s clusters"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [format("%s/32",chomp(data.http.myip.body))]
    description = "ssh"
  }

  ingress {
    from_port   = 749
    to_port     = 749
    protocol    = "udp"
    cidr_blocks = [format("%s/32",chomp(data.http.myip.body))]
    description = "Admin"
  }

  ingress {
    from_port   = 88
    to_port     = 88
    protocol    = "udp"
    cidr_blocks = [format("%s/32",chomp(data.http.myip.body))]
    description = "KDC port"
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
  }
}

module "cp_ec2_pes" {
  source = "../cp-component"
  component = "pes"
  server_sets = var.server_sets
  ami = data.aws_ami.centos.id
  cluster_sg = [aws_security_group.cluster_sg.id]
  subnet_id              = tolist(data.aws_subnet_ids.all.ids)[0]
  key_name               = var.key_name
  domain_name            = var.domain_name
  name_prefix            = var.name_prefix
  user_name              = var.user_name
  dns_zone = var.dns_zone
}
