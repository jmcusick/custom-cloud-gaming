data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name = "architecture"
    values = ["arm64"]
  }
}

data "aws_route53_zone" "custom_cloud_gaming" {
  name         = "customcloudgaming.com."
  private_zone = false
}
