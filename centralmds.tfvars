# Configure the AWS Provider
region = "us-east-1"
dns_zone = "Z3DYW71V76XUGV"
name_prefix = "ivan-mds"
user_name = "ivan"
key_name = "ivan_cloud"
owner_email = "ikunz@confluent.io"
owner_name = "Ivan Kunz"
domain_name = "ps.confluent.io"
server_sets = {
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
        count = 1,
        size = "t3a.medium",
        volume_size = 50,
        dns_name = "controlcenter"
    }
    "ksql" = {
        count = 0,
        size = "t3a.medium",
        volume_size = 50,
        dns_name = "ksql"
    }
  }

