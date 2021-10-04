variable "application_version" {
  default = "1.3"
}

variable "aws_key_pair" {
  default = "C:/Terraform/aws/aws_keys/default-ec2.pem"
}

variable "docker_hub_account" {
  default = "remeric"
}

variable "s3_bucket" {
  default = "terraform-backend-state-remeric-123"
}