# ################################################################################
# # customer_key_pair
# ################################################################################
# locals {
#   customer_private_key_filename = "customer-ssh-key.pem"
# }

# # Create Customer Key Pair in Singapore
# module "customer_key_pair" {
#   source  = "terraform-aws-modules/key-pair/aws"
#   version = "3.0.1"

#   providers = {
#     aws = aws.singapore
#   }

#   key_name           = "customer-key"
#   create_private_key = true

#   private_key_algorithm = "RSA"
#   private_key_rsa_bits  = 4096

#   tags = {
#     Name        = "customer-key"
#     Environment = "Development"
#     Project     = "Customer-Profile"
#   }
# }

# # Save generated private key to local Ubuntu machine
# resource "local_sensitive_file" "customer" {
#   content  = module.customer_key_pair.private_key_openssh
#   filename = pathexpand("~/.ssh/${local.customer_private_key_filename}")

#   file_permission = "0400"
# }

# ################################################################################
# # account_key_pair
# ################################################################################
# locals {
#   account_private_key_filename = "account-ssh-key.pem"
# }

# # Create account Key Pair in Singapore
# module "account_key_pair" {
#   source  = "terraform-aws-modules/key-pair/aws"
#   version = "3.0.1"

#   providers = {
#     aws = aws.tokyo
#   }

#   key_name           = "account-key"
#   create_private_key = true

#   private_key_algorithm = "RSA"
#   private_key_rsa_bits  = 4096

#   tags = {
#     Name        = "account-key"
#     Environment = "Development"
#     Project     = "account-Profile"
#   }
# }

# # Save generated private key to local Ubuntu machine
# resource "local_sensitive_file" "account" {
#   content  = module.account_key_pair.private_key_openssh
#   filename = pathexpand("~/.ssh/${local.account_private_key_filename}")

#   file_permission = "0400"
# }

# ################################################################################
# # statement_key_pair
# ################################################################################
# locals {
#   statement_private_key_filename = "statement-ssh-key.pem"
# }

# # Create statement Key Pair in Singapore
# module "statement_key_pair" {
#   source  = "terraform-aws-modules/key-pair/aws"
#   version = "3.0.1"

#   providers = {
#     aws = aws.seoul
#   }

#   key_name           = "statement-key"
#   create_private_key = true

#   private_key_algorithm = "RSA"
#   private_key_rsa_bits  = 4096

#   tags = {
#     Name        = "statement-key"
#     Environment = "Development"
#     Project     = "statement-Profile"
#   }
# }

# # Save generated private key to local Ubuntu machine
# resource "local_sensitive_file" "statement" {
#   content  = module.statement_key_pair.private_key_openssh
#   filename = pathexpand("~/.ssh/${local.statement_private_key_filename}")

#   file_permission = "0400"
# }


# ################################################################################
# # customer_keypair with resource
# ################################################################################

locals {
  customer_key_filename = "customer-ssh-key.pem"
}

resource "tls_private_key" "customer_keypair" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "customer_keypair" {
  provider   = aws.singapore
  key_name   = local.customer_key_filename
  public_key = tls_private_key.customer_keypair.public_key_openssh
}

resource "local_sensitive_file" "customer" {
  content  = tls_private_key.customer_keypair.private_key_openssh
  filename = pathexpand("~/.ssh/${local.customer_key_filename}")
}

# ################################################################################
# # account_keypair with resource
# ################################################################################
locals {
  account_key_filename = "account-ssh-key.pem"
}

resource "tls_private_key" "account_keypair" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "account_keypair" {
  provider   = aws.tokyo
  key_name   = local.account_key_filename
  public_key = tls_private_key.account_keypair.public_key_openssh
}


resource "local_sensitive_file" "account" {
  content  = tls_private_key.account_keypair.private_key_openssh
  filename = pathexpand("~/.ssh/${local.account_key_filename}")
}

# ################################################################################
# # statement_keypair with resource
# ################################################################################
locals {
  statement_key_filename = "statement-ssh-key.pem"
}


resource "tls_private_key" "statement_keypair" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "statement_keypair" {
  provider   = aws.seoul
  key_name   = local.statement_key_filename
  public_key = tls_private_key.statement_keypair.public_key_openssh
}


resource "local_sensitive_file" "statement" {
  content  = tls_private_key.statement_keypair.private_key_openssh
  filename = pathexpand("~/.ssh/${local.statement_key_filename}")
}
