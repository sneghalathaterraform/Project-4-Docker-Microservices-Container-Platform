resource "aws_ecr_repository" "orders" {
  name = "orders-service"

  tags = {
    Name = "orders-service"
  }
}

resource "aws_ecr_repository" "sales" {
  name = "sales-service"

  tags = {
    Name = "sales-service"
  }
}
