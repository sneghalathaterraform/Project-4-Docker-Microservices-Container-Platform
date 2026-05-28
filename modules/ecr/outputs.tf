output "orders_repository_url" {
  value = aws_ecr_repository.orders.repository_url
}

output "sales_repository_url" {
  value = aws_ecr_repository.sales.repository_url
}
