#Application LoadBalancer Deploy
resource "aws_lb" "jwcho_alb" {
  name               = "${var.name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.jwcho_websg.id]
  subnets            = [aws_subnet.jwcho_pub[*].id]

  tags = {
    "Name" = "${var.name}-alb"
  }

}

resource "aws_lb_target_group" "jwcho_alb_tg" {
  name     = "${var.name}-alb_tg"
  port     = var.port_http
  protocol = "HTTP"
  vpc_id   = aws_vpc.jwcho_vpc.id

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 5
    matcher             = "200"
    path                = "/health.html"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 2
    unhealthy_threshold = 2
  }
}



resource "aws_lb_listener" "jwcho_front-end" {
  load_balancer_arn = aws_lb.jwcho_alb.arn
  port              = var.port_http
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jwcho_alb_tg.arn
  }
}

#=====================================nlb========================================
resource "aws_lb" "jwcho_nlb" {
  name               = "${var.name}-nlb"
  internal           = true
  load_balancer_type = "network"
  security_groups    = [aws_security_group.jwcho_websg.id]
  subnets            = [aws_subnet.jwcho_pri[*].id]

  tags = {
    "Name" = "${var.name}-nlb"
  }

}

resource "aws_lb_target_group" "jwcho_nlb_tg" {
  name     = "${var.name}-nlb_tg"
  port     = var.port_http
  protocol = "HTTP"
  vpc_id   = aws_vpc.jwcho_vpc.id

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 5
    matcher             = "200"
    path                = "/health.html"
    port                = "traffic-port"
    protocol            = "tcp"
    timeout             = 2
    unhealthy_threshold = 2
  }
}


resource "aws_lb_listener" "jwcho_front-end" {
  load_balancer_arn = aws_lb.jwcho_nlb.arn
  port              = var.port_tomcat
  protocol          = "tcp"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jwcho_nlb_tg.arn
  }
}