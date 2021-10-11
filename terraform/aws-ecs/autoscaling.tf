
resource "aws_launch_configuration" "docker_launch_cfg" {
  image_id                    = data.aws_ami.aws-linux-2-ecs-latest.id
  #image_id = "ami-04942e54b391af5d0"
  instance_type               = "t2.micro"
  key_name                    = "default-ec2"
  security_groups             = ["${aws_security_group.BGapp_ecs_sg.id}"]
  associate_public_ip_address = true
  user_data                   = data.template_file.user_data.rendered
  iam_instance_profile        = aws_iam_instance_profile.EcsInstanceRoleProfile.name

}

resource "aws_autoscaling_group" "bgapp_asg" {
  name                 = "bg_asg"
  vpc_zone_identifier  = [tolist(data.aws_subnet_ids.default_subnets.ids)[3]]
  launch_configuration = aws_launch_configuration.docker_launch_cfg.name

  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
}