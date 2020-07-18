variable "region" {
  description = "Region for minecraft server. Note: may have to change key_pair as well"
  type = string
  default = "us-east-2"
}

variable "world_bucket" {
  description = "The S3 bucket storing world files"
  type = string
  default = "ccg-minecraft-worlds"
}
