resource "aws_security_group" "elasticache" {
  name_prefix = "elasticache"
  description = "Elasticache security group"

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [var.eb_sg_id]
  }
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id         = "didactic-redis"
  engine             = "redis"
  node_type          = "cache.t2.micro"
  num_cache_nodes    = 1
  security_group_ids = [aws_security_group.elasticache.id]
}
