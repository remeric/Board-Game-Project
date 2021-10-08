
resource "aws_launch_configuration" "docker_launch_cfg" {
  image_id                    = "ami-04942e54b391af5d0"
  instance_type               = "t2.micro"
  key_name                    = "default-ec2"
  security_groups             = ["${aws_security_group.BGapp_ecs_sg.id}"]
  associate_public_ip_address = true
  #user_data            = "#!/bin/bash\necho ECS_CLUSTER=aws_ecs_cluster.BGapp_ECS_cluster.name >> /etc/ecs/ecs.config"
  user_data = "${data.template_file.user_data.rendered}"
  #enable_monitoring = false
  #ebs_optimized = "false"

  iam_instance_profile = aws_iam_instance_profile.EcsInstanceRoleProfile.name

  #  root_block_device {
  #    volume_size = "20"
  #    volume_type = "gp2"
  #    delete_on_termination = true
  #  }
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