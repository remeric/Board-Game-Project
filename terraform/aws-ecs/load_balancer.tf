resource "aws_lb" "BGapp_load_balancer" {
  name               = "BGapp-load-balancer"
  internal           = false
  load_balancer_type = "application"
  subnets            = [tolist(data.aws_subnet_ids.default_subnets.ids)[1], tolist(data.aws_subnet_ids.default_subnets.ids)[2], tolist(data.aws_subnet_ids.default_subnets.ids)[3]]
  security_groups    = ["${aws_security_group.BGapp_lb_sg.id}"]
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.BGapp_load_balancer.id
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.BGapp_target_group.id
  }
}

resource "aws_lb_target_group" "BGapp_target_group" {
  name     = "BGapp-Target-Group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.default.id
}