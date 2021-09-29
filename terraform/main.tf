#https://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html
#information added from above URL to dockerfile and main.tf to install docker and build and launch container

//create bucket
//Secret Keys

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}


provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "BGapp_user" {
  name = "BGapp_user"
}

resource "aws_default_vpc" "default" {
}

resource "aws_security_group" "BGapp_sg" {
  name   = "BGapp_sg"
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

resource "aws_instance" "BGapp_server" {
  ami                    = data.aws_ami.aws-linux-2-latest.id
  key_name               = "default-ec2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.BGapp_sg.id]
  subnet_id  = tolist(data.aws_subnet_ids.default_subnets.ids)[5]
  depends_on = [data.aws_subnet_ids.default_subnets]

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.aws_key_pair)
  }



  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install -y docker",
      "sudo usermod -a -G docker ec2-user",
      "sudo service docker start",
      "sudo docker pull ${var.docker_hub_account}/board-game-selector:${var.application_version}",
      "sudo docker run -d -t -i -p 80:80 ${var.docker_hub_account}/board-game-selector:${var.application_version}"
    ]
  }
}