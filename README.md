###  Session 21  (Nov 15) : Terraform Modules deep dive

This lab demonstrates deploying a multi-region microservices architecture using Terraform and AWS.

### Architecture
- **Singapore:** Customer Service
- **Tokyo:** Account Service
- **Seoul:** Statement Service

## Terraform Modules

The following Terraform modules are used to build and manage the multi-region AWS infrastructure.

### Infrastructure Modules
| Infrastructure Layer | Terraform Module | Purpose |
|---|---|---|
| Networking | `terraform-aws-modules/vpc/aws` | Creates VPCs, public/private subnets, NAT Gateways, and route tables |
| Connectivity | `grem11n/vpc-peering/aws` | Establishes VPC Peering connections and configures routes |
| Security | `terraform-aws-modules/security-group/aws` | Manages inbound and outbound security group rules |
| Load Balancing | `terraform-aws-modules/alb/aws` | Creates Application Load Balancers, listeners, and target groups |
| Compute | `terraform-aws-modules/ec2-instance/aws` | Deploys EC2 instances and configures Docker using User Data |
| Dns | `terraform-aws-modules/route53/aws` | Using route53 public hosted zone |

### Implementation
- Created three VPCs with public and private subnets.
- Configured Internet Gateways and NAT Gateways.
- Established two VPC Peering connections.
- Deployed EC2 instances using Terraform `user_data`.
- Installed Docker and deployed Fake Service containers.
- Configured three Application Load Balancers and Target Groups.
- Set up Security Groups and route tables.
- Configured Route 53 public hosted zone with an ALB Alias record.
- Enabled service communication: Customer → Account → Statement.

### Testing
- Verified Docker containers on all EC2 instances.
- Confirmed all Target Groups were healthy.
- Tested internal ALB connectivity.
- Verified end-to-end microservice communication.
- Tested public DNS access using `customer.wai-mon.link`.

### Technologies
AWS | Terraform | VPC | EC2 | NAT Gateway | VPC Peering | ALB | Route 53 | Docker | Linux