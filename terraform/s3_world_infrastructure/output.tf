output "s3_ccg_world_buckets_arn" {
  description = "The ARN of the S3 world bucket"
  value       = {
    for bucket in aws_s3_bucket.ccg_worlds:
    bucket.id => bucket.arn
  }
}
