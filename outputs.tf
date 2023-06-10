#output "memcache_endpoint" {
#  value = aws_elasticache_cluster.memcache_datastore.configuration_endpoint
#}

output "db_endpoint" {
  value = aws_db_instance.db_instance.endpoint
}