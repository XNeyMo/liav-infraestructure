resource "aws_instance" "app_server" {
  ami           = "ami-0a0e5d9c7acc336f1"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_http.id, aws_security_group.allow_ssh.id, aws_security_group.access_mysql.id]
  key_name = "michael-key-pairs"
  associate_public_ip_address = true
  tags = {
    Name = "APP SERVER"
  }
}

# Nueva distribución de CloudFront para el backend
resource "aws_cloudfront_distribution" "backend" {
  enabled             = true
  is_ipv6_enabled     = true
  wait_for_deployment = true
  comment             = "Distribución para el Backend"

  origin {
    domain_name = aws_instance.app_server.public_dns  # Utiliza el dns publico de tu instancia EC2
    origin_id   = "backend-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"  # CloudFront se comunica con tu backend a través de HTTP
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "backend-origin"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true
      headers      = ["Origin", "Access-Control-Request-Method", "Access-Control-Request-Headers"]
      cookies {
        forward = "all"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true  # Utiliza el certificado predeterminado de CloudFront
    minimum_protocol_version       = "TLSv1.2_2019"
  }
}





