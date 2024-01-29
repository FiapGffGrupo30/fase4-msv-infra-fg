resource "aws_lb" "gff-alb" {
  name                       = "gff-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.security_group_id]
  subnets                    = var.public_subnet_ids
  enable_deletion_protection = false

  enable_http2                     = true
  idle_timeout                     = 400
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_target_group" "gff-target-group" {
  name        = "gff-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "gff-listener" {
  load_balancer_arn = aws_lb.gff-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gff-target-group.arn
  }
}

resource "aws_lb_listener_rule" "gff-listener-rule" {
  listener_arn = aws_lb_listener.gff-listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gff-target-group.arn
  }

  condition {
    http_request_method {
      values = ["GET", "HEAD", "POST", "PUT", "PATCH"]
    }
  }
}