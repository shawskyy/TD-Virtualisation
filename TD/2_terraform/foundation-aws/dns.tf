resource "aws_route53_zone" "zone" {
  name = "kiowy.com"
}

resource "aws_route53_record" "app" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = "app.${aws_route53_zone.zone.name}"
  type    = "A"
  ttl     = 300
  records = aws_instance.vm[*].public_ip
}
