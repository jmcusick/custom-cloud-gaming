variable "region" {
  description = "Region for minecraft server. Note: may have to change key_pair as well"
  type = string
  default = "us-east-2"
}

variable "aws_profile" {
  description = "AWS profile for credentials"
  type = string
  default = "personal"
}

variable "world_buckets" {
  description = "The S3 buckets storing world files"
  type = set(string)
  default = [
    "ccg-minecraft-worlds",
    "ccg-forest-worlds"
  ]
}
