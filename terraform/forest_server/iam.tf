resource "aws_iam_instance_profile" "ccg_forest_implicit_instance_profile" {
  name = "CcgForestInstanceRole"
  role = aws_iam_role.ccg_forest_implicit_role.name
}

resource "aws_iam_role_policy" "ccg_forest_permit_sts_assume" {
  name = "CcgForestPermitStsAssume"
  role = aws_iam_role.ccg_forest_implicit_role.id
  policy = data.template_file.ccg_forest_sts_assume_policy.rendered
}

resource "aws_iam_role_policy" "ccg_forest_permit_s3" {
  name = "CcgForestPermitS3"
  role = aws_iam_role.ccg_forest_assumed_role.id
  policy = data.template_file.ccg_forest_permit_s3.rendered
}

resource "aws_iam_role" "ccg_forest_implicit_role" {
  name = "CcgForestImplicitRole"
  assume_role_policy = data.aws_iam_policy_document.ccg_forest_implicit_policy.json
}

resource "aws_iam_role" "ccg_forest_assumed_role" {
  name = "CcgForestAssumedRole"
  assume_role_policy = data.aws_iam_policy_document.ccg_forest_assumed_policy.json
}


