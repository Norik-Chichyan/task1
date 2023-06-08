resource "aws_elasticache_cluster" "cache_datastore" {
  cluster_id           = "cache-db-cluster"
  engine               = "memcached"
  node_type            = "cache.m4.large"
  num_cache_nodes      = 2
  parameter_group_name = "default.memcached1.4"
  port                 = 11211
}