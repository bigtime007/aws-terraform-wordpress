#CLoudFront Distribution"
resource "aws_cloudfront_distribution" "tcc-cloudfront" {
  aliases = var.cf_aliases
  comment = var.cf_comment
  enabled = true
  tags    = var.tags_default

  # Apache Orgin
  origin {
    domain_name = aws_lb.tcc-alb.dns_name
    origin_id   = aws_lb.tcc-alb.name

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_protocol_policy   = "match-viewer"
      origin_ssl_protocols     = ["TLSv1.1", "TLSv1.2"]
      origin_keepalive_timeout = 30
      origin_read_timeout      = 45
    }
  }
  /*
  # S3 Orgin for Images
  origin {
    domain_name         = "lurn-cloud-wp-offload-media.s3.amazonaws.com"
    origin_id           = "lurn-cloud-wp-offload-media"
    connection_attempts = 3
    connection_timeout  = 10

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/ECWY62IZISLNC"
    }
  }
  */
  restrictions {
    geo_restriction {
      restriction_type = "blacklist"
      locations        = ["RU"]
    }
  }

  viewer_certificate {
    acm_certificate_arn            = var.tcc_acm
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    default_ttl            = 300
    max_ttl                = 31536000
    min_ttl                = 0
    viewer_protocol_policy = "redirect-to-https"
    target_origin_id       = aws_lb.tcc-alb.name
    compress               = true
    forwarded_values {
      headers      = ["Host", "Origin", "Authorization", "Referer", "Access-Control-Request-Headers"]
      query_string = true

      cookies {
        forward = "whitelist"
        whitelisted_names = [
          "comment_author*",
          "wordpress_*",
          "wp_logged_in_*",
          "wordpress_test_cookie",
          "wordpresspass_*",
          "wp-postpass_*",
          "wp-settings*"
        ]
      }
    }
  }

  ordered_cache_behavior {
    path_pattern           = "/wp-admin/*"
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    default_ttl            = 3600
    max_ttl                = 86400
    min_ttl                = 0
    viewer_protocol_policy = "redirect-to-https"
    compress               = false
    target_origin_id       = aws_lb.tcc-alb.name

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }

      headers = ["*"] # In order to use plug-in: Elementor you have to allow all 
    }
  }

  ordered_cache_behavior {
    path_pattern     = "wp-login.php"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = aws_lb.tcc-alb.name

    forwarded_values {
      query_string = true
      headers      = ["Host", "Origin"]

      cookies {
        forward = "whitelist"
        whitelisted_names = [
          "comment_author*",
          "wordpress_*",
          "wp_logged_in_*",
          "wordpress_test_cookie",
          "wordpresspass_*",
          "wp-postpass_*",
          "wp-settings*",
          "wp_lang"
        ]
      }
    }

    compress               = false
    viewer_protocol_policy = "redirect-to-https"
    default_ttl            = 3600
    max_ttl                = 86400
    min_ttl                = 0
  }

  ordered_cache_behavior {
    path_pattern     = "/wp-content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = aws_lb.tcc-alb.name

    forwarded_values {
      query_string = false
      headers      = ["Host", "Origin"]

      cookies {
        forward = "none"

      }
    }

    compress               = true
    viewer_protocol_policy = "redirect-to-https"
    default_ttl            = 3600
    max_ttl                = 604800
    min_ttl                = 0
  }

  ordered_cache_behavior {
    path_pattern     = "/wp-includes/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = aws_lb.tcc-alb.name

    forwarded_values {
      query_string = true
      headers      = ["Host", "Origin"]

      cookies {
        forward = "whitelist"
        whitelisted_names = [
          "comment_author*",
          "wordpress_*",
          "wp_logged_in_*",
          "wordpress_test_cookie",
          "wordpresspass_*",
          "wp-postpass_*",
          "wp-settings*",
          "wp_lang"
        ]
      }
    }

    compress               = true
    viewer_protocol_policy = "redirect-to-https"
    default_ttl            = 86400
    max_ttl                = 604800
    min_ttl                = 0
  }

  ordered_cache_behavior {
    path_pattern     = "/phpMyAdmin/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = aws_lb.tcc-alb.name

    forwarded_values {
      query_string = true
      headers      = ["*"]

      cookies {
        forward = "all"
      }
    }

    compress               = false
    viewer_protocol_policy = "redirect-to-https"
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 404
  }
}
