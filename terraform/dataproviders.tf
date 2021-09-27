#data "aws_subnet_ids" "default_subnets" {
#  vpc_id = aws_default_vpc.default.id
#}

data "aws_ami" "aws-linux-2-latest" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

}

data "aws_ami_ids" "aws-linux-2-latest_ids" {
  owners = ["amazon"]
}

data "http" "myip" {
  url = "http://icanhazip.com/"
}