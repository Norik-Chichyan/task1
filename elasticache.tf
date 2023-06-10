resource "aws_security_group" "memcache" {
  name        = "memcache-sg"
  description = "Security group for Memcache cluster"

  ingress {
    from_port   = 11211
    to_port     = 11211
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#resource "aws_elasticache_cluster" "memcache_datastore" {
#  cluster_id           = "cache-db-cluster"
#  engine               = "memcached"
#  node_type            = "cache.m4.large"
#  num_cache_nodes      = 2
#  parameter_group_name = "default.memcached1.4"
#  port                 = 11211
#
#  security_group_ids = [
#    aws_security_group.memcache.id
#  ]
#}

