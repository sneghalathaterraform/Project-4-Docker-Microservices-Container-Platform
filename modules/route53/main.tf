# Get the hosted zone
data "aws_route53_zone" "main" {
  zone_id = var.hosted_zone_id
}

# A record pointing to ALB
resource "aws_route53_record" "api" {
  zone_id = var.hosted_zone_id
  name    = var.api_domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}