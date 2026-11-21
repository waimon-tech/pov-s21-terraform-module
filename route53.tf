################################################################################
# Route 53 - Customer ALB DNS Record
################################################################################

module "customer_dns" {
  source  = "terraform-aws-modules/route53/aws"
  version = "6.5.1"

  providers = {
    aws = aws.singapore
  }

  create_zone = false
  name        = "wai-mon.link"

  records = {
    customer = {
      name = "customer"
      type = "A"

      alias = {
        name                   = module.customer_alb.dns_name
        zone_id                = module.customer_alb.zone_id
        evaluate_target_health = true
      }
    }
  }
}