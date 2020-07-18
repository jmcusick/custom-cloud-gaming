output "IP" {
  value = aws_instance.minecraft.public_ip
  description = "The minecraft server ip"
}

output "AssumeRoleARN" {
  value = aws_iam_role.ccg_minecraft_assumed_role.arn
  description = "The role arn for s3 privileges"
}
