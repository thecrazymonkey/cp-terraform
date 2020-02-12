# Configure the AWS Provider
variable "region" {
  default = "us-east-1"
}
variable "dns_zone" {
  # ps.confluent.io
  default = "Z3DYW71V76XUGV"
}
variable "name_prefix" {
  default = "ivan.aws"
}
variable "key_name" {
  default = "ivan_bootcamp"
}

variable "domain_name" {
  default = "ps.confluent.io"
}

variable "server_sets" {
  description = "Describes specific settings for individual CP servers (count, type, .....)"
  default = {
    "zk" = {
        count = 3,
        size = "t3a.micro",
        volume_size = 10,
        dns_name = "zk"
    }
    "broker" = {
        count = 3,
        size = "t3a.medium",
        volume_size = 50,
        dns_name = "kafka"
    }
    "connect" = {
        count = 0,
        size = "t3a.medium",
        volume_size = 40,
        dns_name = "connect"
    }
    "schemaregistry" = {
        count = 0,
        size = "t3a.small",
        volume_size = 30,
        dns_name = "schemaregistry"
    }
    "restproxy" = {
        count = 0,
        size = "t3a.small",
        volume_size = 10,
        dns_name = "restproxy"
    }
    "controlcenter" = {
        count = 0,
        size = "t3a.medium",
        volume_size = 30,
        dns_name = "kafka"
    }
    "ksql" = {
        count = 0,
        size = "t3a.medium",
        volume_size = 30,
        dns_name = "ksql"
    }
  }
}
