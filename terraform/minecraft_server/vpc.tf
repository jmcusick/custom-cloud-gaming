module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "personal-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-2a"]
  public_subnets  = ["10.0.101.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
