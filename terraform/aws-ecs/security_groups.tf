resource "aws_security_group" "BGapp_lb_sg" {
  name   = "BGapp_lb_sg"
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "BGapp_sg"
  }
}

resource "aws_security_group" "BGapp_ecs_sg" {
  name   = "BGapp_ecs_sg"
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port       = 32768
    to_port         = 65535
    protocol        = "tcp"
    security_groups = ["${aws_security_group.BGapp_lb_sg.id}"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    # Automatically lookup your current public IP and set that as an allowed SSH IP
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "BGapp_sg"
  }
}