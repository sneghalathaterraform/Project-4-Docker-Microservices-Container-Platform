resource "aws_ecs_cluster" "main" {
  name = "microservices-cluster"

  tags = {
    Name = "microservices-cluster"
  }
}

resource "aws_cloudwatch_log_group" "orders" {
  name              = "/ecs/orders-service"
  retention_in_days = 7

  tags = {
    Name = "orders-log-group"
  }
}

resource "aws_cloudwatch_log_group" "sales" {
  name              = "/ecs/sales-service"
  retention_in_days = 7

  tags = {
    Name = "sales-log-group"
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = "ecs-task-execution-role"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "orders" {
  family                   = "orders-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = 256
  memory = 512

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "orders-service"
      image = "${var.orders_image_url}:latest"

      portMappings = [{
        containerPort = 8080
      }]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.orders.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "orders-task-definition"
  }
}

resource "aws_ecs_task_definition" "sales" {
  family                   = "sales-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = 256
  memory = 512

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "sales-service"
      image = "${var.sales_image_url}:latest"

      portMappings = [{
        containerPort = 8080
      }]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.sales.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "sales-task-definition"
  }
}

resource "aws_ecs_service" "orders" {
  name            = "orders-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.orders.arn
  launch_type     = "FARGATE"

  desired_count = var.desired_count

  network_configuration {
    subnets = [
      var.private_subnet_1_id,
      var.private_subnet_2_id
    ]

    security_groups = [var.ecs_sg_id]
  }

  load_balancer {
    target_group_arn = var.orders_target_group_arn
    container_name   = "orders-service"
    container_port   = 8080
  }

  tags = {
    Name = "orders-service"
  }
}

resource "aws_ecs_service" "sales" {
  name            = "sales-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.sales.arn
  launch_type     = "FARGATE"

  desired_count = var.desired_count

  network_configuration {
    subnets = [
      var.private_subnet_1_id,
      var.private_subnet_2_id
    ]

    security_groups = [var.ecs_sg_id]
  }

  load_balancer {
    target_group_arn = var.sales_target_group_arn
    container_name   = "sales-service"
    container_port   = 8080
  }

  tags = {
    Name = "sales-service"
  }
}
