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

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
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



