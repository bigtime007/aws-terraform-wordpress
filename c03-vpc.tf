# VPC 
resource "aws_vpc" "vpc-tcc" {
  cidr_block         = "10.0.0.0/16"
  instance_tenancy   = "default"
  enable_dns_support = true
  tags               = var.tags_default
}

# Public Subnet for VPC 
resource "aws_subnet" "vpc-tcc-pub-us-east-2-abc" {
  count                   = length(var.subnet_cidrs_public)
  vpc_id                  = aws_vpc.vpc-tcc.id
  cidr_block              = var.subnet_cidrs_public[count.index]
  availability_zone       = var.avaibility_zones[count.index]
  map_public_ip_on_launch = true
  tags                    = var.tags_default
}

# Internet Gateway
resource "aws_internet_gateway" "vpc-tcc-igw" {
  vpc_id = aws_vpc.vpc-tcc.id
  tags   = var.tags_default
}

# Create Public Route Table
resource "aws_route_table" "vpc-tcc-public-route-table" {
  vpc_id = aws_vpc.vpc-tcc.id
  tags   = var.tags_default
}

# Associate IGW w/Route Table for Internet Access
resource "aws_route" "vpc-tcc-public-route" {
  route_table_id         = aws_route_table.vpc-tcc-public-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc-tcc-igw.id
}

# Associate the Route Table with the Public Subnet
resource "aws_route_table_association" "vpc-tcc-public-route-table-associate" {
  count          = length(var.subnet_cidrs_public)
  route_table_id = aws_route_table.vpc-tcc-public-route-table.id
  subnet_id      = element(aws_subnet.vpc-tcc-pub-us-east-2-abc.*.id, count.index)
}

# Private Sub for VPC 
resource "aws_subnet" "vpc-tcc-pri-us-east-2-abc" {
  count             = length(var.subnet_cidrs_private)
  vpc_id            = aws_vpc.vpc-tcc.id
  cidr_block        = var.subnet_cidrs_private[count.index]
  availability_zone = var.avaibility_zones[count.index]
  tags              = var.tags_default
}

# Create Private Route Table
resource "aws_route_table" "vpc-tcc-pri-route-table" {
  vpc_id = aws_vpc.vpc-tcc.id
  tags   = var.tags_default
}

# Associate the Route Table with the Public Subnet
resource "aws_route_table_association" "vpc-tcc-pri-route-table-associate" {
  route_table_id = aws_route_table.vpc-tcc-pri-route-table.id
  subnet_id      = element(aws_subnet.vpc-tcc-pri-us-east-2-abc.*.id, count.index)
  count          = length(var.subnet_cidrs_private)
}

# Associate NAT instance w/Route Table for Internet Access in Private Sub
resource "aws_route" "vpc-tcc-pri-route" {
  route_table_id         = aws_route_table.vpc-tcc-pri-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.nat_instance.primary_network_interface_id
  depends_on             = [aws_instance.nat_instance]
}


