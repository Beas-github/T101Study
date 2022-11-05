cat <<EOT >> main.tf

resource "aws_lb" "myalb" {
  name               = "t101-alb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.mysubnet1.id, aws_subnet.mysubnet2.id]
  security_groups = [aws_security_group.mysg.id]

  tags = {
    Name = "t101-alb"
  }
}

resource "aws_lb_listener" "myhttp" {
  load_balancer_arn = aws_lb.myalb.arn
  port              = 8080
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found - T101 Study"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "myalbtg" {
  name = "t101-alb-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.db.outputs.vpcid

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-299"
    interval            = 5
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "myalbrule" {
  listener_arn = aws_lb_listener.myhttp.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.myalbtg.arn
  }
}

output "myalb_dns" {
  value       = aws_lb.myalb.dns_name
  description = "The DNS Address of the ALB"
}
EOT