
################################################################################
# 1. jump_host_sg
################################################################################
module "jump_host_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "6.0.0"

  providers = {
    aws = aws.singapore
  }

  name        = var.jump_host_sg_name
  description = "Security group for Singapore Jump Host"
  vpc_id      = module.customer_profile_vpc.vpc_id

  ingress_rules = {
    ssh_from_my_ip = {
      from_port   = 22
      to_port     = 22
      ip_protocol = "tcp"
      description = "SSH from my public IP"
      cidr_ipv4   = var.my_public_ip
    }
  }

  egress_rules = {
    ssh_to_customer = {
      from_port   = 22
      to_port     = 22
      ip_protocol = "tcp"
      description = "SSH to Customer EC2"
      cidr_ipv4   = "10.0.201.0/24"
    }
  }

  tags = {
    Name        = "jump-host-sg"
    Environment = "Development"
  }
}


################################################################################
# 2. customer_alb_sg
################################################################################
module "customer_alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "6.0.0"

  providers = {
    aws = aws.singapore
  }

  name        = var.customer_alb_sg_name
  description = "Security group for Customer internet-facing ALB"
  vpc_id      = module.customer_profile_vpc.vpc_id

  ingress_rules = {
    http_from_internet = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP from Internet"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  egress_rules = {
    app_to_customer_ec2 = {
      from_port   = 9001
      to_port     = 9001
      ip_protocol = "tcp"
      description = "Application traffic to Customer EC2"
      cidr_ipv4   = "10.0.201.0/24"
    }
  }

  tags = {
    Name        = "customer-alb-sg"
    Environment = "Development"
  }
}


################################################################################
# 3. customer_ec2_sg
################################################################################
module "customer_ec2_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "6.0.0"

  providers = {
    aws = aws.singapore
  }

  name        = var.customer_ec2_sg_name
  description = "Security group for Customer EC2"
  vpc_id      = module.customer_profile_vpc.vpc_id

  ingress_rules = {
    app_from_customer_alb = {
      from_port                    = 9001
      to_port                      = 9001
      ip_protocol                  = "tcp"
      description                  = "Application traffic from Customer ALB"
      referenced_security_group_id = module.customer_alb_sg.id
    }

    ssh_from_jump_host = {
      from_port                    = 22
      to_port                      = 22
      ip_protocol                  = "tcp"
      description                  = "SSH from Jump Host"
      referenced_security_group_id = module.jump_host_sg.id
    }
  }

  egress_rules = {
    http_to_account_alb_1 = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP to Account ALB subnet 1"
      cidr_ipv4   = "172.16.201.0/24"
    }

    http_to_account_alb_2 = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP to Account ALB subnet 2"
      cidr_ipv4   = "172.16.202.0/24"
    }

    ssh_to_account_ec2 = {
      from_port   = 22
      to_port     = 22
      ip_protocol = "tcp"
      description = "SSH to Account EC2"
      cidr_ipv4   = "172.16.203.0/24"
    }
    https_to_internet = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTPS to Internet through NAT Gateway"
      cidr_ipv4   = "0.0.0.0/0"
    }

    http_to_internet = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP to Internet through NAT Gateway"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  tags = {
    Name        = "customer-ec2-sg"
    Environment = "Development"
  }
}


################################################################################
# 4. account_alb_sg Tokyo
################################################################################
module "account_alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "6.0.0"

  providers = {
    aws = aws.tokyo
  }

  name        = var.account_alb_sg_name
  description = "Security group for Account internal ALB"
  vpc_id      = module.account_vpc.vpc_id

  ingress_rules = {
    http_from_customer_ec2 = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP from Customer EC2"
      cidr_ipv4   = "10.0.201.0/24"
    }
  }

  egress_rules = {
    app_to_account_ec2 = {
      from_port   = 9002
      to_port     = 9002
      ip_protocol = "tcp"
      description = "Application traffic to Account EC2"
      cidr_ipv4   = "172.16.203.0/24"
    }
  }

  tags = {
    Name        = "account-alb-sg"
    Environment = "Development"
  }
}


################################################################################
# 5. Account EC2 Security Group - Tokyo
################################################################################
module "account_ec2_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "6.0.0"

  providers = {
    aws = aws.tokyo
  }

  name        = var.account_ec2_sg_name
  description = "Security group for Account EC2"
  vpc_id      = module.account_vpc.vpc_id

  ingress_rules = {
    app_from_account_alb = {
      from_port                    = 9002
      to_port                      = 9002
      ip_protocol                  = "tcp"
      description                  = "Application traffic from Account ALB"
      referenced_security_group_id = module.account_alb_sg.id
    }

    ssh_from_customer_ec2 = {
      from_port   = 22
      to_port     = 22
      ip_protocol = "tcp"
      description = "SSH from Customer EC2"
      cidr_ipv4   = "10.0.201.0/24"
    }
  }

  egress_rules = {
    http_to_statement_alb_1 = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP to Statement ALB subnet 1"
      cidr_ipv4   = "172.31.201.0/24"
    }

    http_to_statement_alb_2 = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP to Statement ALB subnet 2"
      cidr_ipv4   = "172.31.202.0/24"
    }

    ssh_to_statement_ec2 = {
      from_port   = 22
      to_port     = 22
      ip_protocol = "tcp"
      description = "SSH to Statement EC2"
      cidr_ipv4   = "172.31.203.0/24"
    }
    https_to_internet = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTPS to Internet through NAT Gateway"
      cidr_ipv4   = "0.0.0.0/0"
    }

    http_to_internet = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP to Internet through NAT Gateway"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  tags = {
    Name        = "account-ec2-sg"
    Environment = "Development"
  }
}


################################################################################
# 6. statement_alb_sg
################################################################################
module "statement_alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "6.0.0"

  providers = {
    aws = aws.seoul
  }

  name        = var.statement_alb_sg_name
  description = "Security group for Statement internal ALB"
  vpc_id      = module.statement_vpc.vpc_id

  ingress_rules = {
    http_from_account_ec2 = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP from Account EC2"
      cidr_ipv4   = "172.16.203.0/24"
    }
  }

  egress_rules = {
    app_to_statement_ec2 = {
      from_port   = 9003
      to_port     = 9003
      ip_protocol = "tcp"
      description = "Application traffic to Statement EC2"
      cidr_ipv4   = "172.31.203.0/24"
    }
  }

  tags = {
    Name        = "statement-alb-sg"
    Environment = "Development"
  }
}


################################################################################
# 7. Statement EC2 Security Group - Seoul
################################################################################
module "statement_ec2_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "6.0.0"

  providers = {
    aws = aws.seoul
  }

  name        = var.statement_ec2_sg_name
  description = "Security group for Statement EC2"
  vpc_id      = module.statement_vpc.vpc_id

  ingress_rules = {
    app_from_statement_alb = {
      from_port                    = 9003
      to_port                      = 9003
      ip_protocol                  = "tcp"
      description                  = "Application traffic from Statement ALB"
      referenced_security_group_id = module.statement_alb_sg.id
    }

    ssh_from_account_ec2 = {
      from_port   = 22
      to_port     = 22
      ip_protocol = "tcp"
      description = "SSH from Account EC2"
      cidr_ipv4   = "172.16.203.0/24"
    }
  }

  egress_rules = {
    all_outbound = {
      ip_protocol = "-1"
      description = "Allow all outbound traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  tags = {
    Name        = "statement-ec2-sg"
    Environment = "Development"
  }
}
