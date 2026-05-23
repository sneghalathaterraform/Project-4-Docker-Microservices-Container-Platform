resource "aws_lb" "main" {
  name               = "microservices-alb"
  load_balancer_type = "application"

  security_groups = [var.alb_sg_id]

  subnets = [
    var.public_subnet_1_id,
    var.public_subnet_2_id
  ]

  tags = {
    Name = "microservices-alb"
  }
}

resource "aws_lb_target_group" "orders" {
  name     = "tg-orders"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  target_type = "ip"

  health_check {
    path            = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }

  tags = {
    Name = "orders-target-group"
  }
}

resource "aws_lb_target_group" "sales" {
  name     = "tg-sales"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  target_type = "ip"

  health_check {
    path            = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }

  tags = {
    Name = "sales-target-group"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Invalid Route"
      status_code  = "404"
    }
  }

  tags = {
    Name = "http-listener"
  }
}

resource "aws_lb_listener_rule" "orders" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.orders.arn
  }

  condition {
    path_pattern {
      values = ["/api/orders/*"]
    }
  }
}

resource "aws_lb_listener_rule" "sales" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sales.arn
  }

  condition {
    path_pattern {
      values = ["/api/sales/*"]
    }
  }
}
