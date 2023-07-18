module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.14.0"
  bucket  = "my-crazy-good-nextjs-bucket"
}

module "cloudfront" {
  source              = "terraform-aws-modules/cloudfront/aws"
  version             = "3.2.1"
  is_ipv6_enabled     = true
  enabled             = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false

  create_origin_access_identity = true
  origin_access_identities = {
    "oai-nextjs" = "cloudfront s3 oai for nextjs website"
  }

  origin = {
    s3 = {
      domain_name = module.s3_bucket.s3_bucket_bucket_regional_domain_name
      s3_origin_config = {
        origin_access_identity = "oai-nextjs" # key from origin_access_identities map
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = "s3" # key from origin map
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }

  custom_error_response = [
    {
      error_code         = 403
      response_code      = 403
      response_page_path = "/index.html"
    }
  ]

  default_root_object = "index.html"
}

data "aws_iam_policy_document" "s3_policy" {
  version = "2012-10-17"

  statement {
    sid       = "1"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${module.s3_bucket.s3_bucket_arn}/*"]
    principals {
      type        = "AWS"
      identifiers = module.cloudfront.cloudfront_origin_access_identity_iam_arns
    }
  }
}

resource "aws_s3_bucket_policy" "s3_policy" {
  bucket = module.s3_bucket.s3_bucket_id
  policy = data.aws_iam_policy_document.s3_policy.json
}
