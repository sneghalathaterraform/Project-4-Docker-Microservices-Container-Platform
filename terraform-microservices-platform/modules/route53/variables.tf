variable "hosted_zone_id" {
  description = "Route53 hosted zone ID"
  type        = string
}

variable "api_domain_name" {
  description = "API domain name"
  type        = string
}

variable "alb_dns_name" {
  description = "ALB DNS name"
  type        = string
}

variable "alb_zone_id" {
  description = "ALB zone ID"
  type        = string
}