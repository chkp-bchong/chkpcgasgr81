output "chkp_ext_alb_fqdn" {
  value       = aws_lb.chkp_ext_alb.dns_name
  description = "The DNS Name of External Application Load Balancer"
}