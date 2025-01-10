// A variable for extracting the external ip of the instance
output "zookeeper_ip" {
 value = module.cp_ec2_zk.*.ip
}
output "kafka_broker_ip" {
 value = module.cp_ec2_bk.*.ip
}
output "schema_registry_ip" {
 value = module.cp_ec2_sr.*.ip
}
output "kafka_connect_ip" {
 value = module.cp_ec2_co.*.ip
}
output "kafka_rest_ip" {
 value = module.cp_ec2_rp.*.ip
}
output "ksql_ip" {
 value = module.cp_ec2_ks.*.ip
}
output "control_center_ip" {
 value = module.cp_ec2_cc.*.ip
}
output "kafka_controller_ip" {
 value = module.cp_ec2_kafka_controller.*.ip
}
output "zookeeper" {
 value = module.cp_ec2_zk.*.hostname
}
output "kafka_broker" {
 value = module.cp_ec2_bk.*.hostname
}
output "schema_registry" {
 value = module.cp_ec2_sr.*.hostname
}
output "kafka_connect" {
 value = module.cp_ec2_co.*.hostname
}
output "kafka_rest" {
 value = module.cp_ec2_rp.*.hostname
}
output "ksql" {
 value = module.cp_ec2_ks.*.hostname
}
output "control_center" {
 value = module.cp_ec2_cc.*.hostname
}

output "kafka_controller" {
 value = module.cp_ec2_kafka_controller.*.hostname
}
