output "cluster_address" {
  value = aws_elasticache_cluster.redis.cluster_address
}

output "port" {
  value = aws_elasticache_cluster.redis.port
}
