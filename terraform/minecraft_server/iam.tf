resource "aws_iam_instance_profile" "ccg_minecraft_implicit_instance_profile" {
  name = "CcgMinecraftInstanceRole"
  role = aws_iam_role.ccg_minecraft_implicit_role.name
}

resource "aws_iam_role_policy" "ccg_minecraft_permit_sts_assume" {
  name = "CcgMinecraftPermitStsAssume"
  role = aws_iam_role.ccg_minecraft_implicit_role.id
  policy = templatefile(
    "${path.module}/resources/AllowAssumeRole.tpl",
    {
      implicit_role_arn = aws_iam_role.ccg_minecraft_implicit_role.arn
    }
  )
}

resource "aws_iam_role_policy" "ccg_minecraft_permit_s3" {
  name = "CcgMinecraftPermitS3"
  role = aws_iam_role.ccg_minecraft_assumed_role.id
  policy = templatefile(
    "${path.module}/resources/CcgMinecraftIninePolicyS3.tpl",
    {
      bucket = var.world_bucket
    }
  )
}

resource "aws_iam_role" "ccg_minecraft_implicit_role" {
  name = "CcgMinecraftImplicitRole"
  assume_role_policy = data.aws_iam_policy_document.ccg_minecraft_implicit_policy.json
}

resource "aws_iam_role" "ccg_minecraft_assumed_role" {
  name = "CcgMinecraftAssumedRole"
  assume_role_policy = data.aws_iam_policy_document.ccg_minecraft_assumed_policy.json
}


