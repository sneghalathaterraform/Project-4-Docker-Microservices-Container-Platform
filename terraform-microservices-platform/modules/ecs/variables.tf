variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "orders_image_url" {
  description = "Orders service image URL"
  type        = string
}

variable "sales_image_url" {
  description = "Sales service image URL"
  type        = string
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
  default     = 2
}

variable "private_subnet_1_id" {
  description = "Private subnet 1 ID"
  type        = string
}

variable "private_subnet_2_id" {
  description = "Private subnet 2 ID"
  type        = string
}

variable "ecs_sg_id" {
  description = "ECS security group ID"
  type        = string
}

variable "orders_target_group_arn" {
  description = "Orders target group ARN"
  type        = string
}

variable "sales_target_group_arn" {
  description = "Sales target group ARN"
  type        = string
}
