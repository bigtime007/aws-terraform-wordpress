# Input Varibles
variable "aws_region" {
  description = "AWS Region Selected"
  type        = string
  default     = "us-east-2"
}

# Profile ID, for default profile
variable "aws_profile" {
  description = "AWS Profile"
  type        = string
}

# Web Server AMI
variable "ec2_ami_id_apahce" {
  description = "AMI ID"
  type        = string
}

# NFS AMI
variable "ec2_ami_id_nfs" {
  description = "AMI ID"
  type        = string
}

# Apache Web Server Instance type
variable "web_instance_type" {
  description = "ec2 Web ASG intance type"
  type        = string
  default     = "t4g.micro"
}

# ALB ACM
variable "alb_acm" {
  description = "ALB ACM"
  type        = string
}

# NAT Server AMI
variable "nat_ami_id" {
  description = "AMI ID"
  type        = string
}

# SSH Key Pair
variable "key_pair" {
  description = "key-for-instance"
  type        = string
}

# Default Tags
variable "tags_default" {
  description = "tags for labeling WP"
  type        = map(string)
  default = {
    Name        = "lurn.cloud"
    User        = "admin"
    Terraform   = "true"
    Environment = "prod"
    Service     = "Wordpress Server"
  }
}

# Public Subnet
variable "subnet_cidrs_public" {
  description = "Subnet cidr for pub sub (length mus match config avaibility_zones)"
  default     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  type        = list(string)
}

# Private Subnet
variable "subnet_cidrs_private" {
  description = "Subnet cidr for pri sub (length mus match config avaibility_zones)"
  default     = ["10.0.16.0/20", "10.0.32.0/20", "10.0.64.0/20"]
  type        = list(string)
}

# List of AZ's us-east-2
variable "avaibility_zones" {
  description = "AZ's in Ohio east-2"
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
  type        = list(string)
}

# Memcached Parameter
variable "memcached-parameter-group" {
  description = "memcached parameter group"
  default     = ["default.memcached1.4", "default.memcached1.5", "default.memcached1.6"]
  type        = list(string)
}

# ACM: Created before terraform plan in AWS Console
variable "tcc_acm" {
  description = "TCC ACM arn, MUST USE US-EAST-1 ACM"
  type        = string
}

# Cloud Front List of Aliases
variable "cf_aliases" {
  description = "Cloud Front Aliases"
  type        = list(any)
}

variable "cf_comment" {
  description = "Cloud Front Comment"
  type        = string
}

# Route 53

variable "tcc_zone_name" {
  description = "URL for route 53 zone"
  type        = string
}

variable "record_tcc-A" {
  description = "A Record for TCC"
  type        = string
}

variable "record_tcc-all-A" {
  description = "A record for TCC *"
  type        = string
}

variable "record_tcc-media-A" {
  description = "A record media.domain.xyz"
  type        = string
}

variable "acm_cname_name" {
  description = "ACM Cname Name from: AWS ACM manger"
  type        = string
}

variable "acm_cname_value" {
  description = "ACM Cname Value from: AWS ACM manager"
  type        = list(any)
}

variable "media_cf_domain" {
  description = "Media Cloud Front Domain"
  type        = string
}

# RDS instance type and other varibles
variable "ec2_rds_instance_type" {
  description = "RDS Instance CPU"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_az_zone_primary" {
  description = "RDS AZ For Primary RDS instance"
  type        = string
}

variable "rds_engine_ver" {
  description = "RDS engine Verision"
  type        = string
  default     = "8.0.28"
}

variable "rds_identifier" {
  description = "RDS Name on AWS"
  type        = string
  default     = "wordpress-database"
}

variable "rds_license_model" {
  description = "license_model"
  type        = string
  default     = "general-public-license"
}

variable "rds_db_name" {
  description = "RDS DB User Name"
  type        = string
}

variable "rds_storage_encrypted" {
  description = "storage_encrypted bool: t or f"
  type        = bool
  default     = false
}

variable "rds_username" {
  description = "RDS username"
  type        = string
}
