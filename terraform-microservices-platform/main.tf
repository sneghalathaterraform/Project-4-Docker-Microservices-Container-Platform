# VPC Module
module "vpc" {
  source = "./modules/vpc"
}

# Security Groups Module
module "security_groups" {
  source = "./modules/security-groups"
  vpc_id = module.vpc.vpc_id
}

# ECR Module
module "ecr" {
  source = "./modules/ecr"
}

# ALB Module
module "alb" {
  source = "./modules/alb"
  
  vpc_id              = module.vpc.vpc_id
  alb_sg_id           = module.security_groups.alb_sg_id
  public_subnet_1_id  = module.vpc.public_subnet_1_id
  public_subnet_2_id  = module.vpc.public_subnet_2_id
}

# ECS Module
module "ecs" {
  source = "./modules/ecs"
  
  aws_region              = var.aws_region
  orders_image_url        = var.orders_image_url != "" ? var.orders_image_url : module.ecr.orders_repository_url
  sales_image_url         = var.sales_image_url != "" ? var.sales_image_url : module.ecr.sales_repository_url
  desired_count           = var.desired_count
  private_subnet_1_id     = module.vpc.private_subnet_1_id
  private_subnet_2_id     = module.vpc.private_subnet_2_id
  ecs_sg_id               = module.security_groups.ecs_sg_id
  orders_target_group_arn = module.alb.orders_target_group_arn
  sales_target_group_arn  = module.alb.sales_target_group_arn
}

# Auto Scaling Module
module "autoscaling" {
  source = "./modules/autoscaling"
  
  ecs_cluster_name    = module.ecs.ecs_cluster_name
  orders_service_name = module.ecs.orders_service_name
  sales_service_name  = module.ecs.sales_service_name
}

# Route53 Module - DISABLED (no hosted