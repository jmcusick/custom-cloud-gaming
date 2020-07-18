variable "instance_type" {
  description = "EC2 instance type for minecraft server. Note: not all AMIs support all instance types"
  type = string
  default = "m6g.large"
}

variable "region" {
  description = "Region for minecraft server. Note: may have to change key_pair as well"
  type = string
  default = "us-east-2"
}

variable "key_pair" {
  description = "Key pair name used for EC2 access"
  type = string
  default = "first_aws_web_server"
}

variable "subdomain_dns_name" {
  description = "The route53 name for the server"
  type = string
  default = "minecraft_test"
}

variable "world_bucket" {
  description = "The S3 bucket storing world files"
  type = string
  default = "ccg-minecraft-worlds"
}
