resource "aws_efs_file_system" "this" {
  creation_token = "${var.environment}-jenkins-efs"
  encrypted      = true

  tags = {
    Name = "${var.environment}-jenkins-efs"
  }
}

resource "aws_efs_mount_target" "this" {
  count           = length(var.subnet_ids)
  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = var.subnet_ids[count.index]
  security_groups = [aws_security_group.efs.id]
}

resource "aws_security_group" "efs" {
  name        = "${var.environment}-jenkins-efs-sg"
  description = "Allow inbound NFS traffic from EKS"
  vpc_id      = var.vpc_id

  ingress {
    description     = "NFS from EKS"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [var.eks_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-jenkins-efs-sg"
  }
}