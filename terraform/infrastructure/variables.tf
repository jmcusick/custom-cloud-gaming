variable "region" {
  description = "Region for s3 state bucket and dynamodb state locks"
  type = string
  default = "us-east-2"
}
