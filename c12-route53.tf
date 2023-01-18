# Route 53 Zone
resource "aws_route53_zone" "tcc-zone" {
  name = "lurn.cloud"
  tags = var.tags_default
}

data "aws_route53_zone" "tcc-zone-data" {
  name         = "lurn.cloud"
  private_zone = false
}

# Route 53 Records
resource "aws_route53_record" "tcc-A" {
  name    = var.record_tcc-A
  zone_id = aws_route53_zone.tcc-zone.zone_id
  type    = "A"
  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.tcc-cloudfront.domain_name
    zone_id                = aws_cloudfront_distribution.tcc-cloudfront.hosted_zone_id
  }
}

resource "aws_route53_record" "tcc-all-A" {
  name    = var.record_tcc-all-A
  zone_id = aws_route53_zone.tcc-zone.zone_id
  type    = "A"
  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.tcc-cloudfront.domain_name
    zone_id                = aws_cloudfront_distribution.tcc-cloudfront.hosted_zone_id
  }
}

resource "aws_route53_record" "tcc-media-A" {
  name    = var.record_tcc-media-A
  zone_id = aws_route53_zone.tcc-zone.zone_id
  type    = "A"
  alias {
    evaluate_target_health = false
    name                   = var.media_cf_domain
    zone_id                = aws_cloudfront_distribution.tcc-cloudfront.hosted_zone_id
  }
}

resource "aws_route53_record" "tcc-acm-CNAME" {
  name    = var.acm_cname_name
  zone_id = aws_route53_zone.tcc-zone.zone_id
  type    = "CNAME"
  records = var.acm_cname_value
  ttl     = 300
}
