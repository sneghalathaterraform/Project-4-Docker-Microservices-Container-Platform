# CloudWatch Log Groups
resource "aws_cloudwatch_log_group" "orders" {
  name              = "/ecs/orders-service"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "sales" {
  name              = "/ecs/sales-service"
  retention_in_days = 30
}

# Orders Task Definition
resource "aws_ecs_task_definition" "orders" {
  family                   = "orders-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "orders-service"
    image     = "${var.orders_image_url}"
    essential = true

    portMappings = [{
      containerPort = 8080
      hostPort      = 8080
      protocol      = "tcp"
    }]

    environment = [{
      name  = "SPRING_PROFILES_ACTIVE"
      value = "prod"
    }]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/orders-service"
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])
}

# Sales Task Definition
resource "aws_ecs_task_definition" "sales" {
  family                   = "sales-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "sales-service"
    image     = "${var.sales_image_url}"
    essential = true

    portMappings = [{
      containerPort = 8083
      hostPort      = 8083
      protocol      = "tcp"
    }]

    environment = [{
      name  = "SPRING_PROFILES_ACTIVE"
      value = "prod"
    }]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/sales-service"
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])
}

# IAM Role for ECS task execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "microservices-cluster"
}

# Orders ECS Service
resource "aws_ecs_service" "orders" {
  name            = "orders-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.orders.arn
  launch_type     = "FARGATE"
  desired_count   = var.desired_count

  network_configuration {
    subnets          = [var.private_subnet_1_id, var.private_subnet_2_id]
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.orders_target_group_arn
    container_name   = "orders-service"
    container_port   = 8080
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role_policy]
}

# Sales ECS Service
resource "aws_ecs_service" "sales" {
  name            = "sales-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.sales.arn
  launch_type     = "FARGATE"
  desired_count   = var.desired_count

  network_configuration {
    subnets          = [var.private_subnet_1_id, var.private_subnet_2_id]
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.sales_target_group_arn
    container_name   = "sales-service"
    container_port   = 8083
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role_policy]
}