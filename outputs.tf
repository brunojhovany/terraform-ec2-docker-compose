output "public_ip" {
  value = aws_instance.server_instance.public_ip
}

output "route53_dns" {
  value = aws_route53_zone.public-zone.name_servers
}
