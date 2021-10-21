#variable "access_key" {}
#variable "secret_key" {}
variable "ssh_public_key" {
  default = "C:/Terraform/aws/aws_keys/default-ec2.pem"
}

variable "application_version" {
  default = "1.3"
}

variable "aws_key_pair" {
  default = "C:/Terraform/aws/aws_keys/default-ec2.pem"
}

#variable "docker_hub_account" {
#  default = "remeric"
#}

variable "docker_image" {
  default="remeric/board-game-selector"
}

variable "s3_bucket" {
  default = "terraform-backend-state-remeric-123"
}

variable "environment" {
  default = "Prod"
}

variable "app_name" {
  default = "BGapp"
}