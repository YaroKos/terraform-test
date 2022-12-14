resource "aws_lb" "alb" {
  name = "${var.prefix}-${var.environment}-alb-petclinic"
  internal = false
  load_balancer_type = "application"
  ip_address_type = "ipv4"
  security_groups = [aws_security_group.service_sg.id]
  subnets = data.aws_subnets.subnets.ids
}

resource "aws_security_group" "service_sg" {
  name = "${var.prefix}-${var.environment}-alb-sg"
  description = "security group for alb"
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_lb_target_group" "target_group" {
  name = "${var.prefix}-${var.environment}-target-group-http"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_default_vpc.default.id

  health_check {
    timeout = 120
    interval = 130
  }

  depends_on = [aws_lb.alb]
}