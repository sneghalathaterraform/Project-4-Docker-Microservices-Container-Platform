# Application Load Balancer
resource "aws_lb" "main" {
  name               = "microservices-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = [var.public_subnet_1_id, var.public_subnet_2_id]
}

# Orders Target Group
resource "aws_lb_target_group" "orders" {
  name        = "tg-orders"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    path                = "/api/orders/health"  # ✅ correct
    matcher             = "200"
  }
}

# Sales Target Group
resource "aws_lb_target_group" "sales" {
  name        = "tg-sales"
  port        = 8083
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    path                = "/api/sales/health"   # ✅ correct
    matcher             = "200"
  }
}

# HTTP Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}

# Orders Listener Rule — path /api/orders*
resource "aws_lb_listener_rule" "orders" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.orders.arn
  }

  condition {
    path_pattern {
      values = ["/api/orders*"]
    }
  }
}

# Sales Listener Rule — path /api/sales*
resource "aws_lb_listener_rule" "sales" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sales.arn
  }

  condition {
    path_pattern {
      values = ["/api/sales*"]
    }
  }
}