###################### ALB Creation ###########################

resource "aws_lb" "test" {
  name               = "tf-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.alb_sg.security_group_id]
  subnets            = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]

  enable_deletion_protection = false


  tags = {
    Environment = "tf-web-app"
  }
}

##################### ALB Listener creation #######################

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}
##################### Target group creation #######################

resource "aws_lb_target_group" "test" {
  name     = "tfweb"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  stickiness {
    type = "lb_cookie"
  }
  health_check {
    matcher = "200-302"
  }
}

output "new_alb_dns" {
  value = aws_lb.test.dns_name
}