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

data "aws_s3_bucket" "world_bucket" {
  bucket = var.world_bucket
}

data "aws_iam_policy_document" "ccg_minecraft_implicit_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ccg_minecraft_assumed_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.ccg_minecraft_implicit_role.arn]
    }
  }
}
