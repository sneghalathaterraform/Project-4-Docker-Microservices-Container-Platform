variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
  default     = 2
}

variable "orders_image_url" {
  description = "Orders service image URL from ECR"
  type        = string
  default     = ""
}

variable "sales_image_url" {
  description = "Sales service image URL from ECR"
  type        = string
  default     = ""
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID"
  type        = string
  default     = ""
}

variable "api_domain_name" {
  description = "API domain name"
  type        = string
  default     = "api.example.com"
}

