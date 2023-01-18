# EC2 Web IAM Role
resource "aws_iam_policy" "web-s3-policy" {
  description = "Allow WP Media Plugin to access s3 on aws acct"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "ObjectLevel",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:PutObjectAcl"
        ],
        "Resource" : "arn:aws:s3:::*/*"
      },
      {
        "Sid" : "BucketLevel",
        "Effect" : "Allow",
        "Action" : [
          "s3:GetBucketPublicAccessBlock",
          "s3:PutBucketPublicAccessBlock",
          "s3:CreateBucket",
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ],
        "Resource" : "arn:aws:s3:::*"
      },
      {
        "Sid" : "AccountLevel",
        "Effect" : "Allow",
        "Action" : "s3:ListAllMyBuckets",
        "Resource" : "*"
      }
    ]
    }
  )
}

# IAM Role for web instance s3 access
resource "aws_iam_role" "ec2-role-s3" {
  name = "ec2-role-s3"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Principal" : {
          "Service" : [
            "ec2.amazonaws.com"
          ]
        }
      }
    ]
    }
  )
}

# ec2 attach role policy for s3 wp-media-offload allows for S3 Changes.
resource "aws_iam_policy_attachment" "ec2-role-s3" {
  name       = "ec2 attachment s3 web wp-media-offload"
  roles      = [aws_iam_role.ec2-role-s3.name]
  policy_arn = aws_iam_policy.web-s3-policy.arn
}

# Allows for IAM Role to be assigned to ASG Auto Scaling Group
resource "aws_iam_instance_profile" "asg-instance-profile" {
  name = "asg-instance-profile"
  role = aws_iam_role.ec2-role-s3.name
}