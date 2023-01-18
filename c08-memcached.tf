# Parameter_group
resource "aws_elasticache_subnet_group" "tcc-pri-mem-subnetg" {
  name       = "tcc-pri-subnet-g"
  subnet_ids = ["${aws_subnet.vpc-tcc-pri-us-east-2-abc[2].id}"]
}

# Memcached Resource
resource "aws_elasticache_cluster" "memcached-tcc" {
  cluster_id           = "tccmemcached"
  engine               = "memcached"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.memcached1.6"
  subnet_group_name    = aws_elasticache_subnet_group.tcc-pri-mem-subnetg.id
  security_group_ids   = ["${aws_security_group.elastic-cache-sg.id}"]
  port                 = 11211
  availability_zone    = "us-east-2c"
}