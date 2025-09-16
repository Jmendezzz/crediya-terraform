# Load Balancer interno
resource "aws_lb" "this" {
  name               = "${var.project}-internal-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.sg_id]   # SG que permita tráfico desde API Gateway
  subnets            = var.private_subnets

  tags = {
    Name = "${var.project}-alb"
  }
}

# Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "No matching rule found"
      status_code  = "404"
    }
  }
}

# -------------------------
# Target Groups
# -------------------------
resource "aws_lb_target_group" "auth" {
  name        = "${var.project}-auth-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    path                = "/api/v1/auth/health"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
    matcher             = "200-399"
  }
}

resource "aws_lb_target_group" "loan" {
  name        = "${var.project}-loan-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    path              = "/api/v1/loan-applications/health"
    healthy_threshold = 2
    matcher           = "200-399"
  }
}

resource "aws_lb_target_group" "report" {
  name        = "${var.project}-report-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    path              = "/api/v1/report-metrics/health"
    healthy_threshold = 2
    matcher           = "200-399"
  }
}

# -------------------------
# Listener Rules
# -------------------------
resource "aws_lb_listener_rule" "auth" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.auth.arn
  }

  condition {
    path_pattern {
      values = ["/api/v1/auth/*", "/api/v1/users/*"]
    }
  }
}

resource "aws_lb_listener_rule" "loan" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.loan.arn
  }

  condition {
    path_pattern {
      values = ["/api/v1/loan-applications/*"]
    }
  }
}

resource "aws_lb_listener_rule" "report" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 3

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.report.arn
  }

  condition {
    path_pattern {
      values = ["/api/v1/report-metrics/*"]
    }
  }
}
