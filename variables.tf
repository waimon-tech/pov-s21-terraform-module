################################################################################
# customer_profile_vpc
################################################################################

variable "customer_profile_vpc_name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "customer_profile_vpc_cidr" {
  description = "(Optional) The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id`"
  type        = string
  default     = "10.0.0.0/16"
}

variable "customer_profile_vpc_azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

variable "customer_profile_vpc_public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "customer_profile_vpc_private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

################################################################################
# account_vpc
################################################################################

variable "account_vpc_name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "account_vpc_cidr" {
  description = "(Optional) The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id`"
  type        = string
  default     = "10.0.0.0/16"
}

variable "account_vpc_azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

variable "account_vpc_public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "account_vpc_private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}


################################################################################
# statement_vpc
################################################################################

variable "statement_vpc_name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "statement_vpc_cidr" {
  description = "(Optional) The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id`"
  type        = string
  default     = "10.0.0.0/16"
}

variable "statement_vpc_azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

variable "statement_vpc_public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "statement_vpc_private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

################################################################################
# customer_security_group
################################################################################
variable "my_public_ip" {
  description = "My public IP address for SSH access"
  type        = string
}

variable "jump_host_sg_name" {
  description = "Name of security group"
  type        = string
  default     = ""
}

variable "customer_alb_sg_name" {
  description = "Name of security group"
  type        = string
  default     = ""
}

variable "customer_ec2_sg_name" {
  description = "Name of security group"
  type        = string
  default     = ""
}


################################################################################
# account_security_group
################################################################################

variable "account_alb_sg_name" {
  description = "Name of security group"
  type        = string
  default     = ""
}

variable "account_ec2_sg_name" {
  description = "Name of security group"
  type        = string
  default     = ""
}

################################################################################
# statement_security_group
################################################################################

variable "statement_alb_sg_name" {
  description = "Name of security group"
  type        = string
  default     = ""
}

variable "statement_ec2_sg_name" {
  description = "Name of security group"
  type        = string
  default     = ""
}


################################################################################
# compute variables
################################################################################

variable "jump_host_ec2_name" {
  description = "Name to be used on EC2 instance created"
  type        = string
  default     = ""
}

variable "customer_ec2_name" {
  description = "Name to be used on customer EC2 instance created"
  type        = string
  default     = ""
}

variable "account_ec2_name" {
  description = "Name to be used on account EC2 instance created"
  type        = string
  default     = ""
}

variable "statement_ec2_name" {
  description = "Name to be used on statement EC2 instance created"
  type        = string
  default     = ""
}
