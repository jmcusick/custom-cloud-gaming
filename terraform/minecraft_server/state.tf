terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "jmorgancusick-terraform-state"
    key            = "global/ccg/minecraft/terraform.tfstate"
    region         = "us-east-2"
    profile        = "personal"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "jmorgancusick-terraform-state-locks"
    encrypt        = true
  }
}
