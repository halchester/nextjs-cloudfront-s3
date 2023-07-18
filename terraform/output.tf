output "s3" {
  description = "S3 module outputs"

  value = {
    bucket_id  = module.s3_bucket.s3_bucket_id
    bucket_arn = module.s3_bucket.s3_bucket_arn
  }
}


output "cloudfront" {
  description = "Cloudfront module outputs"

  value = {
    distribution_id = module.cloudfront.cloudfront_distribution_id
    domain          = module.cloudfront.cloudfront_distribution_domain_name
    arn             = module.cloudfront.cloudfront_distribution_arn
    oai_ids         = module.cloudfront.cloudfront_origin_access_identities
  }
}
