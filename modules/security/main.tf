resource "aws_security_group" "ansible" {
  name        = "${var.environment}-ansible-sg"
  description = "Security group for Ansible server in ${var.environment}"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-ansible-sg"
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "ansible_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_cidr_block]
  security_group_id = aws_security_group.ansible.id
}

resource "aws_iam_role" "ansible_role" {
  name = "${var.environment}-ansible-role"

//trusted entity ec2
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}


# Create the IAM policy for  ansible to interact with cluster
resource "aws_iam_policy" "eks_ansible_policy" {
  name        = "${var.environment}-eks-ansible-policy"
  path        = "/"
  description = "IAM policy for Ansible to manage EKS clusters"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach the policy to the ansible role
resource "aws_iam_role_policy_attachment" "eks_ansible_policy_attachment" {
  policy_arn = aws_iam_policy.eks_ansible_policy.arn
  role       = aws_iam_role.ansible_role.name
}


resource "aws_iam_role_policy_attachment" "ssm_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ansible_role.name
}




# AWS SSM uses an S3 bucket to store the results of commands run on EC2 instances.
# Ansible needs to read these results to know if its tasks succeeded or failed.
# Without specifying an S3 bucket, Ansible can't get this information, so it can't work properly with SSM
resource "aws_iam_role_policy_attachment" "ansible_s3_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.ansible_role.name
}

# resource "aws_iam_role_policy_attachment" "eks_read_only" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSReadOnlyAccess"
#   role       = aws_iam_role.ansible_role.name
# }



resource "aws_iam_instance_profile" "ansible_profile" {
  name = "${var.environment}-ansible-profile"
  role = aws_iam_role.ansible_role.name
}



