output "IP" {
  value = aws_instance.minecraft.public_ip
  description = "The minecraft server ip"
}

output "s3_ccg_minecraft_worlds_bucket_arn" {
  value       = aws_s3_bucket.ccg_minecraft_worlds.arn
  description = "The ARN of the S3 world bucket"
}
