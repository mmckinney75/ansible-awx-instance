resource "aws_route53_record" "ansible_awx_record" {
  zone_id = "${data.aws_route53_zone.dns_zone.zone_id}"
  name    = "awx"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_alb.ansible-awx-alb.dns_name}"]
}

resource "aws_route53_record" "default_ws_record" {
  count   = "${var.count}"
  zone_id = "${data.aws_route53_zone.dns_zone.zone_id}"
  name    = "ws${(count.index)+1}"
  type    = "A"
  ttl     = "300"
  records = ["${element(aws_instance.default-web-ubuntu.*.public_ip, count.index)}"]
}
