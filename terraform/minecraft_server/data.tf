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

data "template_file" "ccg_minecraft_sts_assume_policy" {
  template = file("${path.module}/resources/AllowAssumeRole.tpl")

  vars = {
    implicit_role_arn = aws_iam_role.ccg_minecraft_implicit_role.arn
  }
}

data "template_file" "ccg_minecraft_permit_s3" {
  template = file("${path.module}/resources/CcgMinecraftIninePolicyS3.tpl")

  vars = {
    bucket = var.world_bucket
  }
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

data "template_file" "minecraft_server_init_script" {
  template = file("${path.module}/resources/minecraft_server_init.tpl")

  vars = {
    role_arn = aws_iam_role.ccg_minecraft_assumed_role.arn
    s3_bucket = var.s3_server_bucket
    s3_object = var.s3_server_object
  }
}
