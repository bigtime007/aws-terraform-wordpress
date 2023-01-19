#ALB For Apache Instances
resource "aws_lb" "tcc-alb" {
  name                       = "tcc-alb-web"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb-sg.id]
  subnets                    = [aws_subnet.vpc-tcc-pub-us-east-2-abc[2].id, aws_subnet.vpc-tcc-pub-us-east-2-abc[1].id, aws_subnet.vpc-tcc-pub-us-east-2-abc[0].id]
  enable_deletion_protection = false
  tags                       = var.tags_default
}

# ALB Listener HTTP Port 80
resource "aws_lb_listener" "tcc-listener-80" {
  load_balancer_arn = aws_lb.tcc-alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tcc-web-tg-http.arn
  }
}

# ALB Listener HTTPS Port 443, acm most be created in same region, but first in us-east-1 for CF
resource "aws_lb_listener" "tcc-listener-443" {
  load_balancer_arn = aws_lb.tcc-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.alb_acm
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tcc-web-tg-http.arn
  }
}

# ALB target Group Apache Instances
resource "aws_lb_target_group" "tcc-web-tg-http" {
  name     = "tcc-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc-tcc.id
}

# Auto Scaling Attachment Apache Instances
resource "aws_autoscaling_attachment" "tcc-web-ag-attach" {
  autoscaling_group_name = aws_autoscaling_group.tcc-asg-web.id
  lb_target_group_arn    = aws_lb_target_group.tcc-web-tg-http.arn
}

# Apache Launch Temp
resource "aws_launch_template" "tcc-l-t-web" {
  image_id               = var.ec2_ami_id_apahce
  instance_type          = var.web_instance_type
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.ec2-apache-sg.id]
  tags = {
    Name = "WP Apache Web Server"
  }
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 8
    }
  }

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.asg-instance-profile.name
  }

  monitoring {
    enabled = true
  }

  placement {
    availability_zone = "us-east-2c"
  }
}

# Auto Scaling Policy 
resource "aws_autoscaling_policy" "target-tracking-scaling" {
  name                      = "Target-Tracking-Scaling"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 250
  autoscaling_group_name    = aws_autoscaling_group.tcc-asg-web.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 8.0
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "tcc-asg-web" {
  name                      = "tcc-asg-web"
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  tag {
    key                 = "Name"
    value               = "WP Apache Web Server"
    propagate_at_launch = true
  }
  vpc_zone_identifier = [aws_subnet.vpc-tcc-pri-us-east-2-abc[1].id, aws_subnet.vpc-tcc-pri-us-east-2-abc[2].id]

  launch_template {
    id      = aws_launch_template.tcc-l-t-web.id
    version = "$Latest"
  }

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
}