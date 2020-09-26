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
    "pes" = {
        count = 1,
        size = "t3a.nano",
        volume_size = 10,
        dns_name = "pes"
    }
  }
}
