################################################################################
# jump_host_ec2
################################################################################
module "jump_host_ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.0.2"

  providers = {
    aws = aws.singapore
  }

  name = var.jump_host_ec2_name

  ami_ssm_parameter = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"

  instance_type = "t3.micro"
  key_name      = aws_key_pair.customer_keypair.key_name

  subnet_id = module.customer_profile_vpc.public_subnets[0]

  # Use only the existing default Security Group
  create_security_group = false

  vpc_security_group_ids = [
    module.jump_host_sg.id
  ]

  associate_public_ip_address = true

  root_block_device = {
    volume_type = "gp3"
    volume_size = 8
    encrypted   = true
  }

  tags = {
    Name        = "jump-host"
    Environment = "Development"
    Project     = "Customer-Profile"
  }
}

################################################################################
# customer_ec2
################################################################################
module "customer_ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.0.2"

  providers = {
    aws = aws.singapore
  }

  name = var.customer_ec2_name

  instance_type = "t3.micro"
  key_name      = aws_key_pair.customer_keypair.key_name

  subnet_id = module.customer_profile_vpc.private_subnets[0]

  # Use only the existing default Security Group
  create_security_group = false

  vpc_security_group_ids = [
    module.customer_ec2_sg.id
  ]

  associate_public_ip_address = false

  root_block_device = {
    volume_type = "gp3"
    volume_size = 8
    encrypted   = true
  }

  tags = {
    Name        = "customer-ec2"
    Environment = "Development"
    Project     = "Customer-Profile"
  }

  user_data = <<-EOF
  #!/bin/bash
  set -eux

  dnf install -y docker

  systemctl enable --now docker

  docker pull nicholasjackson/fake-service:v0.23.1

  docker run -d \
    --name customer-service \
    --restart unless-stopped \
    -p 9001:9001 \
    -e LISTEN_ADDR=0.0.0.0:9001 \
    -e UPSTREAM_URIS="http://internal-account-alb-1374040602.ap-northeast-1.elb.amazonaws.com" \
    -e MESSAGE="Customer Service" \
    -e NAME="Customer" \
    -e SERVER_TYPE="http" \
    nicholasjackson/fake-service:v0.23.1
EOF
}


################################################################################
# account_ec2
################################################################################

module "account_ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.0.2"

  providers = {
    aws = aws.tokyo
  }

  name = var.account_ec2_name

  ami_ssm_parameter = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"

  instance_type = "t3.micro"
  key_name      = aws_key_pair.account_keypair.key_name

  subnet_id = module.account_vpc.private_subnets[2]

  # Use only the existing Security Group
  create_security_group = false

  vpc_security_group_ids = [
    module.account_ec2_sg.id
  ]

  associate_public_ip_address = false

  root_block_device = {
    volume_type = "gp3"
    volume_size = 8
    encrypted   = true
  }

  tags = {
    Name        = "account-ec2"
    Environment = "Development"
    Project     = "Account"
  }

  user_data = <<-EOF
  #!/bin/bash
  set -eux

  dnf update -y
  dnf install -y docker

  systemctl enable docker
  systemctl start docker

  docker pull nicholasjackson/fake-service:v0.23.1

  docker run -d \
    --name account-service \
    --restart unless-stopped \
    -p 9002:9002 \
    -e LISTEN_ADDR=0.0.0.0:9002 \
    -e UPSTREAM_URIS="http://internal-statement-alb-2036356702.ap-northeast-2.elb.amazonaws.com" \
    -e MESSAGE="Account Service" \
    -e NAME="Account" \
    -e SERVER_TYPE="http" \
    nicholasjackson/fake-service:v0.23.1
EOF
}


################################################################################
# statement_ec2
################################################################################

module "statement_ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.0.2"

  providers = {
    aws = aws.seoul
  }

  name = var.statement_ec2_name

  ami_ssm_parameter = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"

  instance_type = "t3.micro"
  key_name      = aws_key_pair.statement_keypair.key_name

  subnet_id = module.statement_vpc.private_subnets[2]

  # Use only the existing Security Group
  create_security_group = false

  vpc_security_group_ids = [
    module.statement_ec2_sg.id
  ]

  associate_public_ip_address = false

  root_block_device = {
    volume_type = "gp3"
    volume_size = 8
    encrypted   = true
  }

  tags = {
    Name        = "statement-ec2"
    Environment = "Development"
    Project     = "Statement"
  }

  user_data = <<-EOF
  #!/bin/bash
  set -eux

  dnf update -y
  dnf install -y docker

  systemctl enable docker
  systemctl start docker

  docker pull nicholasjackson/fake-service:v0.23.1

  docker run -d \
    --name statement-service \
    --restart unless-stopped \
    -p 9003:9003 \
    -e LISTEN_ADDR=0.0.0.0:9003 \
    -e MESSAGE="Statement Service" \
    -e NAME="Statement" \
    -e SERVER_TYPE="http" \
    nicholasjackson/fake-service:v0.23.1
EOF
}
