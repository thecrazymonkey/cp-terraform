# Configure the AWS Provider
variable "region" {
  default = "us-east-1"
}
variable "dns_zone" {
  # nerdynick
  default = "Z7RSBY5AAK0K7"
}

variable "name_prefix" {
  default = "ivan"
}
variable "key_name" {
  default = "ivan_bootcamp"
}
variable "server_sets" {
  description = "Describes specific settings for individual CP servers (count, type, .....)"
  default = {
    "zk" = {
        count = 3,
        size = "t3a.small",
        volume_size = 10
    }
    "broker" = {
        count = 3,
        size = "t3a.medium",
        volume_size = 50
    }
    "connect" = {
        count = 0,
        size = "t3a.medium",
        volume_size = 40
    }
    "schemaregistry" = {
        count = 0,
        size = "t3a.small",
        volume_size = 30
    }
    "restproxy" = {
        count = 0,
        size = "t3a.small",
        volume_size = 10
    }
    "controlcenter" = {
        count = 0,
        size = "t3a.medium",
        volume_size = 30
    }
    "ksql" = {
        count = 0,
        size = "t3a.medium",
        volume_size = 30
    }
  }
}
