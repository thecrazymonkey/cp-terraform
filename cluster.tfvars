# Configure the AWS Provider
region = "us-east-1"
dns_zone = "Z3DYW71V76XUGV"
name_prefix = "ivan"
user_name = "ivan"
key_name = "ivan_cloud"
owner_email = "ikunz@confluent.io"
owner_name = "Ivan Kunz"
domain_name = "ps.confluent.io"
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
        count = 6,
        size = "r5.xlarge",
        volume_size = 500,
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
        size = "r5.xlarge",
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

