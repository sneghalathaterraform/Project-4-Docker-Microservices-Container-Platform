variable "aws_region" {
  type = string
}

variable "orders_image_url" {
  type = string
}

variable "sales_image_url" {
  type = string
}

variable "desired_count" {
  type    = number
  default = 2
}

variable "private_subnet_1_id" {
  type = string
}

variable "private_subnet_2_id" {
  type = string
}

variable "ecs_sg_id" {
  type = string
}

variable "orders_target_group_arn" {
  type = string
}

variable "sales_target_group_arn" {
  type = string
}