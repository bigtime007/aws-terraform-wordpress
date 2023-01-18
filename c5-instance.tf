# NAT instance for private subnets
resource "aws_instance" "nat_instance" {
  ami               = var.nat_ami_id
  instance_type     = "t2.micro"
  key_name          = var.key_pair
  subnet_id         = aws_subnet.vpc-tcc-pub-us-east-2-abc[2].id
  source_dest_check = false //Required for NAT
  tags              = var.tags_default
}

# NFS for WP 
resource "aws_instance" "ec2_wp_nfs" {
  ami                    = var.ec2_ami_id_nfs
  instance_type          = "t4g.nano"
  key_name               = var.key_pair
  subnet_id              = aws_subnet.vpc-tcc-pri-us-east-2-abc[2].id
  vpc_security_group_ids = [aws_security_group.nfs-sg.id]
  tags                   = var.tags_default
  private_ip             = "10.0.69.128" # Assign IP for Apache Config
  depends_on             = [aws_instance.nat_instance]
}
