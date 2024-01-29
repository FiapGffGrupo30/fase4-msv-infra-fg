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


//data "aws_subnet_ids" "selected_subnets" {
//  vpc_id = var.vpc_id
//
//  tags = {
//    Name = "${var.prefix}-subnet-public-*"
//  }
//}
//
//resource "aws_lb_target_group_attachment" "gff-target-group-attachment" {
//  count             = length(data.aws_subnet_ids.selected_subnets.ids)
//  target_group_arn = aws_lb_target_group.gff-target-group.arn
//  target_id         = data.aws_subnet_ids.selected_subnets.ids[count.index]
//
//  // Substitua o trecho abaixo com os detalhes específicos da sua configuração
//  port = 80
//}
//
//resource "aws_lb_target_group_attachment" "gff-target-attachment-2" {
//  target_group_arn = aws_lb_target_group.gff-target-group.arn
//  target_id        = "10.0.1.0/24"  # Substitua pelo outro intervalo de endereços IP desejado
//}

//resource "aws_lb_listener" "gff-alb-listener" {
//  load_balancer_arn = aws_lb.gff-alb.arn
//  port              = 80
//  protocol          = "HTTP"
//
//  default_action {
//    type = "fixed-response"
//
//    fixed_response {
//      content_type = "text/plain"
//      status_code  = "200"
//    }
//  }
//}

//resource "aws_lb_target_group_attachment" "gff-alb-tg-attachment" {
//  target_group_arn = aws_lb_target_group.gff-alb-tg.arn
//  target_id        = aws_instance.example.id
//}

//resource "aws_lb_target_group" "gff-alb-tg" {
//  name     = "gff-alb-tg"
//  port     = 80
//  protocol = "HTTP"
//  vpc_id   = var.vpc_id
//
//  health_check {
//    protocol            = "HTTP"
//    path                = "/healthcheck"
//    interval            = 30
//    timeout             = 10
//    healthy_threshold   = 2
//    unhealthy_threshold = 2
//    matcher             = "200,204"
//  }
//}