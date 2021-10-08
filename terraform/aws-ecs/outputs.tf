output "lb_hostname" {
  value = aws_lb.BGapp_load_balancer.dns_name
}