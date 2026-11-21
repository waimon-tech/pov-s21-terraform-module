################################################################################
# customer_account_peering
################################################################################
module "customer_account_peering" {
  source  = "grem11n/vpc-peering/aws"
  version = "8.0.0"

  providers = {
    aws.this = aws.singapore
    aws.peer = aws.tokyo
  }

  name = "customer-account-peering"

  # VPC IDs
  this_vpc_id = module.customer_profile_vpc.vpc_id
  peer_vpc_id = module.account_vpc.vpc_id

  # Automatically accept peering
  auto_accept_peering = true

  # Singapore private route table
  this_rts_ids = module.customer_profile_vpc.private_route_table_ids

  # Tokyo private route table
  peer_rts_ids = module.account_vpc.private_route_table_ids

  tags = {
    Name        = "customer-account-peering"
    Environment = "Development"
    Project     = "Customer-Profile"
  }
}



################################################################################
# account_statement_peering
################################################################################

module "account_statement_peering" {
  source  = "grem11n/vpc-peering/aws"
  version = "8.0.0"

  providers = {
    aws.this = aws.tokyo
    aws.peer = aws.seoul
  }

  name = "account-statement-peering"

  # VPC IDs
  this_vpc_id = module.account_vpc.vpc_id
  peer_vpc_id = module.statement_vpc.vpc_id

  # Automatically accept peering
  auto_accept_peering = true

  # Tokyo private route table
  this_rts_ids = module.account_vpc.private_route_table_ids

  # Seoul private route table
  peer_rts_ids = module.statement_vpc.private_route_table_ids

  tags = {
    Name        = "account-statement-peering"
    Environment = "Development"
    Project     = "Account-Statement"
  }
}


