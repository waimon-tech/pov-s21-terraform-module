###  Session 21  (Nov 15) : Terraform Modules deep dive

This lab demonstrates deploying a multi-region microservices architecture using Terraform and AWS.

### Architecture
- **Singapore:** Customer Service
- **Tokyo:** Account Service
- **Seoul:** Statement Service

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