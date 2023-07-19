output "s3" {
  description = "S3 module outputs"

  value = {
    bucket_id  = module.s3_bucket.s3_bucket_id
  }
}


output "cloudfront" {
  description = "Cloudfront module outputs"

  value = {
    distribution_id = module.cloudfront.cloudfront_distribution_id
    domain          = module.cloudfront.cloudfront_distribution_domain_name
  }
}
