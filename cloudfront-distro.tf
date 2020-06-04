locals {
  origin_id       = "Custom-Dongs"
  domain_name     = "${var.hostname}.${var.domainname}"
}
#, "${var.instance_name}.${var.domainname}"

resource "aws_cloudfront_distribution" "streamline_distribution" {
  aliases = ["${var.hostname}.${var.domainname}"]
  origin {
    domain_name = aws_route53_record.streamline_instance.fqdn
    origin_id   = "${local.origin_id}-${local.domain_name}"
    custom_header {
      name  = "Access-Control-Allow-Origin"
      value = "*"
    }
    custom_origin_config {
      http_port                = "80"
      https_port                = "80"
      origin_protocol_policy   = "http-only"
      origin_ssl_protocols     = ["TLSv1.1", "TLSv1.2"]
      origin_keepalive_timeout = "5"
      origin_read_timeout      = "30"
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = "Streamline CDN Distribution"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.origin_id}-${local.domain_name}"

    forwarded_values {
      query_string = false
      headers      = ["*"]

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "*.m3u8"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.origin_id}-${local.domain_name}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 1
    max_ttl                = 1
    compress               = false
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate_validation.streamline.certificate_arn
    ssl_support_method = "sni-only"
    #cloudfront_default_certificate = true
  }
}

#, "${var.instance_name}.${var.domainname}"
resource "aws_acm_certificate" "streamline" {
  #us-east-1 required for ACM + cloudfront https://aws.amazon.com/premiumsupport/knowledge-center/custom-ssl-certificate-cloudfront/
  provider = aws.east
  domain_name       = "${var.hostname}.${var.domainname}"
  subject_alternative_names = ["${var.hostname}.${var.domainname}"]
  validation_method = "DNS"
  tags = {
    Environment = "test"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  name    = aws_acm_certificate.streamline.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.streamline.domain_validation_options.0.resource_record_type
  zone_id = data.aws_route53_zone.selected.zone_id
  records = [aws_acm_certificate.streamline.domain_validation_options.0.resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "streamline" {
  provider = aws.east
  certificate_arn         = aws_acm_certificate.streamline.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}
