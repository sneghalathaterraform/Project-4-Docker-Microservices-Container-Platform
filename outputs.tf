output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "ALB Zone ID"
  value       = module.alb.alb_zone_id
}

output "ecs_cluster_name" {
  description = "ECS Cluster name"
  value       = module.ecs.ecs_cluster_name
}

output "orders_service_name" {
  description = "Orders service name"
  value       = module.ecs.orders_service_name
}

output "sales_service_name" {
  description = "Sales service name"
  value       = module.ecs.sales_service_name
}

output "orders_repository_url" {
  description = "Orders ECR Repository URL"
  value       = module.ecr.orders_repository_url
}

output "sales_repository_url" {
  description = "Sales ECR Repository URL"
  value       = module.ecr.sales_repository_url
}

