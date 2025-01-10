# Configure the AWS Provider
region = "us-east-1"
dns_zone = "Z01489812B6V0685KWQLS"
name_prefix = "ivan"
user_name = "ivan"
key_name = "ivan-nova"
owner_email = "ikunz@confluent.io"
owner_name = "Ivan Kunz"
domain_name = "aws.cse.confluent.io"
ami = {
  # AWS Linux 2023
  owner = "137112412989"
  name_regex = "Amazon Linux 2023 AMI*"
}
server_sets = {
    "zk" = {
        count = 0,
        size = "t3a.medium",
        volume_size = 10,
        dns_name = "zk"
        volume_type = "gp2"
    }
    "kafka_controller" = {
        count = 3,
        size = "t3a.medium",
        volume_size = 10,
        dns_name = "kraft"
        volume_type = "gp2"
    }
    "broker" = {
        count = 3,
        size = "t3a.large",
        volume_size = 300,
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
        size = "t3a.xlarge",
        volume_size = 50,
        dns_name = "controlcenter"
        volume_type = "gp2"
    }
    "ksql" = {
        count = 0,
        size = "r5.xlarge",
        volume_size = 50,
        dns_name = "ksql"
        volume_type = "gp2"
    }
  }

