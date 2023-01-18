# Random Block for s3 names
resource "random_pet" "pet-string" {
  length    = 4
  separator = "-"
  #min = 10
  #max = 20
}

# S3 Media Offload Bucket
resource "aws_s3_bucket" "s3-media" {
  bucket = "media-offload-tcc-${random_pet.pet-string.id}"
  acl    = "private"
  tags   = var.tags_default
}

# S3 CloudFront Logging Bucket
resource "aws_s3_bucket" "cloudfront-bucket-logs" {
  bucket = "cf-logging-tcc-${random_pet.pet-string.id}"
  acl    = "private"
  tags   = var.tags_default
}

# S3 ALB Logging Bucket
resource "aws_s3_bucket" "alb-bucket-logs" {
  bucket = "alb-logging-bucket-tcc-${random_pet.pet-string.id}"
  acl    = "private"
  tags   = var.tags_default
}