#output "memcache_endpoint" {
#  value = aws_elasticache_cluster.memcache_datastore.configuration_endpoint
#}

output "db_endpoint" {
  value = aws_db_instance.db_instance.endpoint
}

output "cloudfront_dist_domain_name" {
  value = aws_cloudfront_distribution.cf_dist.domain_name
}

output "s3_site_origin_name" {
  value = aws_s3_bucket.artifactes.bucket_regional_domain_name
}