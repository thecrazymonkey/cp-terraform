# Configure the AWS Provider
variable "region" {
  default = "us-east-1"
}
variable "dns_zone" {
  # ps.confluent.io
  default = "Z3DYW71V76XUGV"
}
variable "name_prefix" {
  default = "ivan"
}
variable "user_name" {
  default = "ivan"
}
variable "key_name" {
  default = "ivan_cloud"
}
variable "owner_email" {
  default = "ikunz@confluent.io"
}
variable "owner_name" {
  default = "Ivan Kunz"
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
        count = 4,
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
        volume_size = 50,
        dns_name = "controlcenter"
    }
    "ksql" = {
        count = 0,
        size = "t3a.medium",
        volume_size = 30,
        dns_name = "ksql"
    }
  }
}
