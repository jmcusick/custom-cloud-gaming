resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.custom_cloud_gaming.zone_id
  name    = "${var.subdomain_dns_name}.${data.aws_route53_zone.custom_cloud_gaming.name}"
  type    = "A"
  ttl = "300"
  records = [aws_instance.forest.public_ip]
}
