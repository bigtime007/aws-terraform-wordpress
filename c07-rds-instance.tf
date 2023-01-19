# DB subnet group
resource "aws_db_subnet_group" "db-subg-tcc" {
  name       = "tcc-private-sub-group"
  subnet_ids = aws_subnet.vpc-tcc-pri-us-east-2-abc.*.id
  tags       = var.tags_default
}

# RDS Instance for WP
resource "aws_db_instance" "wordpress-database" {
  instance_class                        = var.ec2_rds_instance_type
  allocated_storage                     = 20
  apply_immediately                     = false
  availability_zone                     = var.rds_az_zone_primary
  backup_retention_period               = 7
  backup_window                         = "12:00-12:30"
  ca_cert_identifier                    = "rds-ca-2019"
  copy_tags_to_snapshot                 = true
  customer_owned_ip_enabled             = false
  db_subnet_group_name                  = aws_db_subnet_group.db-subg-tcc.name
  deletion_protection                   = false
  enabled_cloudwatch_logs_exports       = []
  engine                                = "mysql"
  engine_version                        = "8.0.28"
  iam_database_authentication_enabled   = false
  identifier                            = var.rds_identifier
  iops                                  = 0
  license_model                         = "general-public-license"
  maintenance_window                    = "mon:00:00-mon:00:30"
  max_allocated_storage                 = 0
  multi_az                              = false
  db_name                               = var.rds_db_name
  network_type                          = "IPV4"
  option_group_name                     = "default:mysql-8-0"
  parameter_group_name                  = "default.mysql8.0"
  performance_insights_retention_period = 0
  port                                  = 3306
  skip_final_snapshot                   = true
  storage_encrypted                     = var.rds_storage_encrypted
  storage_throughput                    = 0
  storage_type                          = "gp2"
  tags                                  = {}
  tags_all                              = {}
  username                              = var.rds_username
  vpc_security_group_ids                = [aws_security_group.rds-sg.id]
}