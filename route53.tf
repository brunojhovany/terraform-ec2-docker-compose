resource "aws_route53_zone" "public-zone" {
  name = var.project_domain_name
  comment = "${var.project_domain_name} public zone"
  provider = aws
}

resource "aws_route53_record" "medusa-record" {
    count = length(var.project_subdomains)
    zone_id = aws_route53_zone.public-zone.id
    name    = "${var.project_subdomains[count.index]}${var.project_domain_name}"
    type    = "A"
    ttl     = "300"
    records = [aws_instance.server_instance.public_ip]
    depends_on = [
      aws_instance.server_instance
    ]
}