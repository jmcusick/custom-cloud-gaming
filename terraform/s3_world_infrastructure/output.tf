output "s3_ccg_minecraft_worlds_bucket_arn" {
  value       = aws_s3_bucket.ccg_minecraft_worlds.arn
  description = "The ARN of the S3 world bucket"
}
