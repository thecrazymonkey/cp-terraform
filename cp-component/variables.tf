variable "component" {
  description = "Name to be used to select from the set"
  type        = string
}

variable "ami" {
  description = "AWS ami"
  type        = string
}

variable "server_sets" {
  description = "Copy of server sets"
  type        = map(map(string))
}

variable "cluster_sg" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
  default     = ""
}
variable "key_name" {
  description = "Key name"
  type        = string
  default     = ""
}

variable "name_prefix" {
  type        = string
}

variable "domain_name" {
  type        = string
}

variable "dns_zone" {
  type        = string
}
