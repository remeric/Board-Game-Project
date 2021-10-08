#Reminders:

#Using defvault VPN, using below for Public subnets
#[tolist(data.aws_subnet_ids.default_subnets.ids)[1], tolist(data.aws_subnet_ids.default_subnets.ids)[2], tolist(data.aws_subnet_ids.default_subnets.ids)[3]]

#Using defvault VPN, using below for private subnets
#[tolist(data.aws_subnet_ids.default_subnets.ids)[4], tolist(data.aws_subnet_ids.default_subnets.ids)[5], tolist(data.aws_subnet_ids.default_subnets.ids)[0]]

#Default Gateway already present on Default VPC

#https://github.com/terraform-aws-modules/terraform-aws-ecs/blob/master/examples/complete-ecs/main.tf

