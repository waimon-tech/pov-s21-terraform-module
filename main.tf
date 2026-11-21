################################################################################
# customer
################################################################################
module "customer_profile_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.7.3"

  providers = {
    aws = aws.singapore
  }

  name = var.customer_profile_vpc_name
  cidr = var.customer_profile_vpc_cidr
  azs  = var.customer_profile_vpc_azs

  public_subnets  = var.customer_profile_vpc_public_subnets
  private_subnets = var.customer_profile_vpc_private_subnets

  # NAT Gateway
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_dns_support   = true
  enable_dns_hostnames = true

}

################################################################################
# account
################################################################################
module "account_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.7.3"

  providers = {
    aws = aws.tokyo
  }

  name = var.account_vpc_name
  cidr = var.account_vpc_cidr
  azs  = var.account_vpc_azs

  public_subnets  = var.account_vpc_public_subnets
  private_subnets = var.account_vpc_private_subnets

  # NAT Gateway
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

}

################################################################################
# statement
################################################################################
module "statement_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.7.3"

  providers = {
    aws = aws.seoul
  }

  name = var.statement_vpc_name
  cidr = var.statement_vpc_cidr
  azs  = var.statement_vpc_azs

  public_subnets  = var.statement_vpc_public_subnets
  private_subnets = var.statement_vpc_private_subnets

  # NAT Gateway
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
}
