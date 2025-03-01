# Configure the AWS Provider
variable "region" {
  default = "us-east-1"
}
variable "dns_zone" {
  # some.zone.io
  default = "BLAHBLAH"
}
variable "name_prefix" {
  default = "test"
}
variable "user_name" {
  default = "test"
}
variable "key_name" {
  default = "test_key"
}
variable "owner_email" {
  default = "test@some.io"
}
variable "owner_name" {
  default = "test"
}
variable "domain_name" {
  default = "some.zone.io"
}
variable "ami" {
  # AWS Linux 2023
  default = {
    owner = 137112412989
    ami = "ami-06b21ccaeff8cd686"
    name_regex = ""
  }
}

variable "server_sets" {
  description = "Describes specific settings for individual CP servers (count, type, .....)"
  default = {
    "zk" = {
        count = 0,
        size = "t3a.micro",
        volume_size = 10,
        dns_name = "zk"
        volume_type = "gp2"
    }
    "kraft" = {
        count = 3,
        size = "t3a.micro",
        volume_size = 10,
        dns_name = "kraft"
        volume_type = "gp2"
    }
    "broker" = {
        count = 3,
        size = "t3a.medium",
        volume_size = 50,
        dns_name = "kafka"
        volume_type = "gp2"
    }
    "connect" = {
        count = 0,
        size = "t3a.medium",
        volume_size = 40,
        dns_name = "connect"
        volume_type = "gp2"
    }
    "schemaregistry" = {
        count = 0,
        size = "t3a.small",
        volume_size = 30,
        dns_name = "schemaregistry"
        volume_type = "gp2"
    }
    "restproxy" = {
        count = 0,
        size = "t3a.small",
        volume_size = 10,
        dns_name = "restproxy"
        volume_type = "gp2"
    }
    "controlcenter" = {
        count = 1,
        size = "t3a.medium",
        volume_size = 50,
        dns_name = "controlcenter"
        volume_type = "gp2"
    }
    "ksql" = {
        count = 0,
        size = "t3a.medium",
        volume_size = 50,
        dns_name = "ksql"
        volume_type = "gp2"
    }
  }
}
