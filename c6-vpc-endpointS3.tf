# VPC Endpoint
resource "aws_vpc_endpoint" "tcc-s3" {
  vpc_id            = aws_vpc.vpc-tcc.id
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.us-east-2.s3"
  route_table_ids   = [aws_route_table.vpc-tcc-pri-route-table.id]
  tags              = var.tags_default

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "Allows ec2 Access-to-bucket in Private VPC",
    "Statement" : [
      {
        "Action" : "*",
        "Effect" : "Allow",
        "Resource" : "*",
        "Principal" : "*"
      }
    ]
  })
}

