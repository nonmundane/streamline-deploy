locals {
  origin_id       = "Custom-Dongs"
  domain_name     = "${var.hostname}.${var.domainname}"
}

resource "aws_cloudfront_distribution" "streamline_distribution" {
  origin {
    domain_name = local.domain_name
    origin_id   = "${local.origin_id}-${local.domain_name}"
    custom_header {
      name  = "Access-Control-Allow-Origin"
      value = "*"
    }
    custom_origin_config {
      http_port                = "80"
      https_port               = "443"
      origin_protocol_policy   = "http-only"
      origin_ssl_protocols     = ["TLSv1"]
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

    viewer_protocol_policy = "allow-all"
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
    viewer_protocol_policy = "allow-all"
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
