provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "tfstate" {
  bucket = "${var.environment}-tfstate-bucket"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "${var.environment}-tfstate-bucket"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_policy" "tfstate_policy" {
  bucket = aws_s3_bucket.tfstate.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowAccessForTerraform",
        Effect    = "Allow",
        Principal = {
          AWS = [
            "arn:aws:iam::533267308718:user/Hari-TF",
            "arn:aws:iam::533267308718:user/Rohan-TF"
          ]
        },
        Action    = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ],
        Resource  = [
          "${aws_s3_bucket.tfstate.arn}",
          "${aws_s3_bucket.tfstate.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "terraform_s3_role" {
  name = "${var.environment}-terraform-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"  
        }
      }
    ]
  })
}

resource "aws_iam_policy" "terraform_s3_policy" {
  name        = "${var.environment}-terraform-s3-policy"
  description = "Policy to allow access to S3 bucket for Terraform state"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ],
        Resource = [
          "${aws_s3_bucket.tfstate.arn}",
          "${aws_s3_bucket.tfstate.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "terraform_s3_policy_attachment" {
  role       = aws_iam_role.terraform_s3_role.name
  policy_arn  = aws_iam_policy.terraform_s3_policy.arn
}

