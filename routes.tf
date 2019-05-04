resource "aws_route53_zone" "patrickhousley_dev" {
  name = "patrickhousley.dev"
}

resource "aws_route53_record" "patrickhousley_dev_email" {
  zone_id = "${aws_route53_zone.patrickhousley_dev.zone_id}"
  name = ""
  type = "MX"
  records = [
    "5 gmr-smtp-in.l.google.com.",
    "10 alt1.gmr-smtp-in.l.google.com.",
    "20 alt2.gmr-smtp-in.l.google.com.",
    "30 alt3.gmr-smtp-in.l.google.com.",
    "40 alt4.gmr-smtp-in.l.google.com.", 
  ]
  ttl = "3600"
}

resource "aws_route53_record" "patrickhousley_dev_www_naked" {
  zone_id = "${aws_route53_zone.patrickhousley_dev.zone_id}"
  name    = ""
  type    = "A"

  alias = {
    name = "${aws_cloudfront_distribution.www_distribution.domain_name}"
    zone_id = "${aws_cloudfront_distribution.www_distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "patrickhousley_dev_www" {
  zone_id = "${aws_route53_zone.patrickhousley_dev.zone_id}"
  name    = "www"
  type    = "A"

  alias = {
    name = "${aws_cloudfront_distribution.www_distribution.domain_name}"
    zone_id = "${aws_cloudfront_distribution.www_distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}
