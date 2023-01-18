#AlB SG for Wordpress port 80,443 ingress from client or cloudfront
resource "aws_security_group" "alb-sg" {
  name        = "alb-sg"
  description = "ALB SG for WP"
  vpc_id      = aws_vpc.vpc-tcc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow port 80"
    from_port   = 80
    protocol    = "tcp"
    self        = false
    to_port     = 80
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    self        = false
  }
  egress {
    description = "Allow all IP and Ports outbound to client or Cloudfront"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Apache EC2 SG for Auto Scaling or apache install
resource "aws_security_group" "ec2-apache-sg" {
  name        = "ec2-apache-sg-tcc"
  description = "ec2 sg for apache in ASG or install instance"
  vpc_id      = aws_vpc.vpc-tcc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    self        = false
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    self        = false
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH Allow port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    self        = false
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "pinging: Allow port ICMP"
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    self        = false
  }
  ingress {
    cidr_blocks = ["73.73.31.114/32"]
    description = "pinging: Allow port ICMP"
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    self        = false
  }
  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    description = "allow nfs access"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    self        = false
  }
  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    description = "RDS mysql access for wp"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    self        = false
  }
  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    description = "Memchace mysql access for wp-apahce"
    from_port   = 11211
    to_port     = 11211
    protocol    = "tcp"
    self        = false
  }
  egress {
    description = "Allow all IP and Ports outbound to client or Cloudfront"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for RDS instance for WP database access
resource "aws_security_group" "rds-sg" {
  name        = "tcc-wordpress-db"
  description = "DB for Worpress TCC"
  vpc_id      = aws_vpc.vpc-tcc.id

  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    description = "RDS mysql access for wp"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    self        = false
  }
  egress {
    description = "Allow all IP and Ports outbound to client or Cloudfront"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# NFS SG 
resource "aws_security_group" "nfs-sg" {
  name        = "nfs-sg-tcc"
  description = "NFS SG for TCC"
  vpc_id      = aws_vpc.vpc-tcc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    self        = false
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    self        = false
  }
  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    description = "SSH Allow port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    self        = false
  }
  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    description = "pinging: Allow port ICMP"
    from_port   = 0
    to_port     = 0
    protocol    = "ICMP"
    self        = false
  }
  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    description = "allow nfs access"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    self        = false
  }
  egress {
    description = "Allow all IP and Ports to VPC only"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Allow access to Memchaced managed service
resource "aws_security_group" "elastic-cache-sg" {
  name        = "memcached-tcc"
  description = "memcahced for wp"
  vpc_id      = aws_vpc.vpc-tcc.id

  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    description = "Memchace mysql access for wp-apahce"
    from_port   = 11211
    to_port     = 11211
    protocol    = "tcp"
    self        = false
  }
  egress {
    description = "Allow all IP and Ports outbound with in VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }
}

# NAT SG for private subnet for apache and nfs layer
resource "aws_security_group" "nat-sg" {
  name        = "nat-sg-tcc"
  description = "nat sg for private sub internet"
  vpc_id      = aws_vpc.vpc-tcc.id
  tags        = var.tags_default

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    self        = false
  }
  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    description = "Allow port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    self        = false
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH Allow port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    self        = false
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "pinging: Allow port ICMP"
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    self        = false
  }
  ingress {
    cidr_blocks = ["73.73.31.114/32"]
    description = "pinging: Allow port ICMP"
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    self        = false
  }
  egress {
    description = "Allow all IP and Ports outbound to client or Cloudfront"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
