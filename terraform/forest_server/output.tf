output "IP" {
  value = aws_instance.forest.public_ip
  description = "The forest server ip"
}

output "AssumeRoleARN" {
  value = aws_iam_role.ccg_forest_assumed_role.arn
  description = "The role arn for s3 privileges"
}
