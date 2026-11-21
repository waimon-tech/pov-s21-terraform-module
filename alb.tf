
################################################################################
# 1. Customer ALB - Singapore
################################################################################
module "customer_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "10.5.1"

  providers = {
    aws = aws.singapore
  }

  name = "customer-profile-alb"

  load_balancer_type = "application"
  internal           = false

  vpc_id = module.customer_profile_vpc.vpc_id

  # Use existing Customer ALB Security Group
  create_security_group = false

  security_groups = [
    module.customer_alb_sg.id
  ]

  # Two public subnets in different AZs
  subnets = [
    module.customer_profile_vpc.public_subnets[0],
    module.customer_profile_vpc.public_subnets[1]
  ]

  # Target Group
  target_groups = {
    customer = {
      name        = "customer-tg"
      protocol    = "HTTP"
      port        = 9001
      target_type = "instance"

      vpc_id    = module.customer_profile_vpc.vpc_id
      target_id = module.customer_ec2.id

      health_check = {
        enabled             = true
        healthy_threshold   = 3
        unhealthy_threshold = 3
        interval            = 30
        timeout             = 5
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }
  }

  # HTTP Listener
  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"

      forward = {
        target_group_key = "customer"
      }
    }
  }

  enable_deletion_protection = false

  tags = {
    Name        = "customer-profile-alb"
    Environment = "Development"
    Project     = "Customer-Profile"
  }
}


################################################################################
# 2. Account ALB - Tokyo
################################################################################
module "account_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "10.5.1"

  providers = {
    aws = aws.tokyo
  }

  name = "account-alb"

  load_balancer_type = "application"
  internal           = true

  vpc_id = module.account_vpc.vpc_id

  # Use existing Account ALB Security Group
  create_security_group = false

  security_groups = [
    module.account_alb_sg.id
  ]

  # Two private subnets in different AZs
  subnets = [
    module.account_vpc.private_subnets[0],
    module.account_vpc.private_subnets[2]
  ]

  # Target Group
  target_groups = {
    account = {
      name        = "account-tg"
      protocol    = "HTTP"
      port        = 9002
      target_type = "instance"

      vpc_id    = module.account_vpc.vpc_id
      target_id = module.account_ec2.id

      health_check = {
        enabled             = true
        healthy_threshold   = 3
        unhealthy_threshold = 3
        interval            = 30
        timeout             = 5
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }
  }

  # HTTP Listener
  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"

      forward = {
        target_group_key = "account"
      }
    }
  }

  enable_deletion_protection = false

  tags = {
    Name        = "account-alb"
    Environment = "Development"
    Project     = "Account"
  }
}


################################################################################
# 3. Statement ALB - Seoul
################################################################################
module "statement_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "10.5.1"

  providers = {
    aws = aws.seoul
  }

  name = "statement-alb"

  load_balancer_type = "application"
  internal           = true

  vpc_id = module.statement_vpc.vpc_id

  # Use existing Statement ALB Security Group
  create_security_group = false

  security_groups = [
    module.statement_alb_sg.id
  ]

  # Two private subnets in different AZs
  subnets = [
    module.statement_vpc.private_subnets[0],
    module.statement_vpc.private_subnets[2]
  ]
  # Target Group
  target_groups = {
    statement = {
      name        = "statement-tg"
      protocol    = "HTTP"
      port        = 9003
      target_type = "instance"

      vpc_id    = module.statement_vpc.vpc_id
      target_id = module.statement_ec2.id

      health_check = {
        enabled             = true
        healthy_threshold   = 3
        unhealthy_threshold = 3
        interval            = 30
        timeout             = 5
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }
  }

  # HTTP Listener
  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"

      forward = {
        target_group_key = "statement"
      }
    }
  }

  enable_deletion_protection = false

  tags = {
    Name        = "statement-alb"
    Environment = "Development"
    Project     = "Statement"
  }
}
