resource "aws_iam_instance_profile" "ccg_minecraft_implicit_instance_profile" {
  name = "CcgMinecraftInstanceRole"
  role = aws_iam_role.ccg_minecraft_implicit_role.name
}

resource "aws_iam_role_policy" "ccg_minecraft_permit_sts_assume" {
  name = "CcgMinecraftPermitStsAssume"
  role = aws_iam_role.ccg_minecraft_implicit_role.id
  policy = data.template_file.ccg_minecraft_sts_assume_policy.rendered
}

resource "aws_iam_role_policy" "ccg_minecraft_permit_s3" {
  name = "CcgMinecraftPermitS3"
  role = aws_iam_role.ccg_minecraft_assumed_role.id
  policy = data.template_file.ccg_minecraft_permit_s3.rendered
}

resource "aws_iam_role" "ccg_minecraft_implicit_role" {
  name = "CcgMinecraftImplicitRole"
  assume_role_policy = data.aws_iam_policy_document.ccg_minecraft_implicit_policy.json
}

resource "aws_iam_role" "ccg_minecraft_assumed_role" {
  name = "CcgMinecraftAssumedRole"
  assume_role_policy = data.aws_iam_policy_document.ccg_minecraft_assumed_policy.json
}


