resource "aws_lb" "load_balancer" {
  name               = "${var.app_name}-${var.environment}-Load-Balancer"
  internal           = false
  load_balancer_type = "application"
  subnets            = [tolist(data.aws_subnet_ids.default_subnets.ids)[1], tolist(data.aws_subnet_ids.default_subnets.ids)[2], tolist(data.aws_subnet_ids.default_subnets.ids)[3]]
  security_groups    = ["${aws_security_group.lb_sg.id}"]

  tags = {
    Environment = "${var.environment}"
    App_Name    = "${var.app_name}"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.load_balancer.id
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }
}

resource "aws_lb_target_group" "target_group" {
  name     = "${var.app_name}-${var.environment}-Target-Group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.default.id

  tags = {
    Environment = "${var.environment}"
    App_Name    = "${var.app_name}"
  }
}