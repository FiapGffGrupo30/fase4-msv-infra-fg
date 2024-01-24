resource "aws_lb" "gff-alb" {
  name               = "gff-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.public_subnet_ids
  enable_deletion_protection = false

  enable_http2      = true
  idle_timeout      = 400
  enable_cross_zone_load_balancing = true
  //enable_logging = false
}

resource "aws_lb_listener" "gff-alb-listener" {
  load_balancer_arn = aws_lb.gff-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
    }
  }
}

//resource "aws_lb_target_group_attachment" "gff-alb-tg-attachment" {
//  target_group_arn = aws_lb_target_group.gff-alb-tg.arn
//  target_id        = aws_instance.example.id
//}

resource "aws_lb_target_group" "gff-alb-tg" {
  name     = "gff-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    protocol            = "HTTP"
    path                = "/healthcheck"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200,204"
  }
}