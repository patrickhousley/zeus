resource "aws_cloudfront_distribution" "www_distribution" {
  // origin is where CloudFront gets its content from.
  origin {
    domain_name = "${aws_s3_bucket.www_patrickhousley_dev.bucket_regional_domain_name}"
    origin_id = "patrickhousley.dev"
    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.patrickhousley_dev_origin_access.cloudfront_access_identity_path}"
    }
  }

  enabled  = true
  default_root_object = "index.html"
  aliases = ["patrickhousley.dev", "www.patrickhousley.dev"]

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    compress = true
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "patrickhousley.dev"
    min_ttl = 0
    default_ttl = 86400
    max_ttl = 31536000
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = "${aws_acm_certificate.patrickhousley_dev_certificate.arn}"
    ssl_support_method  = "sni-only"
  }
}

resource "aws_cloudfront_origin_access_identity" "patrickhousley_dev_origin_access" {
  comment = "Access S3 bucket content only through CloudFront"
}
