
data "aws_subnet_ids" "default_subnets" {
  vpc_id = aws_default_vpc.default.id
}

data "aws_ami" "aws-linux-2-ecs-latest" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*"]
  }

}

data "http" "myip" {
  url = "http://icanhazip.com/"
}

data "template_file" "user_data" {
  template = file("${path.module}/templates/user_data.sh")
}