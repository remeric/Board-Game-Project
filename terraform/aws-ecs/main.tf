terraform {
  backend "s3" {
    bucket         = "terraform-backend-state-remeric"
    key            = "bgapp/aws-ecs/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "application_locks"
    encrypt        = "true"
  }
}

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
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_default_vpc" "default" {
}

resource "aws_ecs_cluster" "BGapp_ECS_cluster" {
  name = "BGapp_ECS_cluster"
}

resource "aws_ecs_task_definition" "BGapp_Container_Task_Def" {
  family                   = "BGapp"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "BGapp",
      "image": "remeric/board-game-selector:${var.application_version}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 0
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  memory                   = 512
  cpu                      = 512
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn

}

resource "aws_ecs_service" "BGapp_ecs_service" {
  name            = "BGapp_ecs_service"
  cluster         = aws_ecs_cluster.BGapp_ECS_cluster.id
  desired_count   = 1
  task_definition = aws_ecs_task_definition.BGapp_Container_Task_Def.arn
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = aws_lb_target_group.BGapp_target_group.arn
    container_name   = aws_ecs_task_definition.BGapp_Container_Task_Def.family
    container_port   = 80
  }

}
