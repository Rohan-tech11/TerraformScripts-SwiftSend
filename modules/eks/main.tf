resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = var.private_subnet_ids
  }
  access_config {
    authentication_mode = var.authentication_mode
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  instance_types = var.instance_types

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_container_registry_read_only,
  ]
}

// Creating trusted entity as eks
resource "aws_iam_role" "eks_cluster" {
  name = "${var.environment}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

// Attaching policy to the role assumed by eks cluster
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

// IAM role for eks nodes (EC2)
resource "aws_iam_role" "eks_nodes" {
  name = "${var.environment}-eks-node-role"

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

// Attachment of policies to eks worker nodes
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes.name
}

// Creating access entry for ansible server 
resource "aws_eks_access_entry" "ansible_server" {
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = var.ansible_role_arn
  type          = "STANDARD"  
}

// Creating access policy for ansible role
resource "aws_eks_access_policy_association" "ansible_edit_access" {
  cluster_name  = aws_eks_cluster.this.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy"
  principal_arn = var.ansible_role_arn
  access_scope {
    type = "cluster"
  }
}

// Resources for IRSA and Jenkins service account
data "tls_certificate" "eks" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource "aws_iam_role" "jenkins_ecr_access_role" {
  name = "${var.environment}-jenkins-ecr-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        }
        Condition = {
          StringEquals = {
            "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub": "system:serviceaccount:jenkins:jenkins-sa"
          }
        }
      }
    ]
  })
}

// Updated IAM policy document for Jenkins EKS access
data "aws_iam_policy_document" "jenkins_eks_access_policy" {
  statement {
    actions = [
      "eks:*",  // Full access to all EKS actions
      "ec2:DescribeInstances",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs",
      "iam:PassRole",
    ]
    effect    = "Allow"
    resources = ["*"]  // Allow access to all resources
  }
  
  statement {
    actions   = ["sts:AssumeRole"]
    effect    = "Allow"
    resources = [aws_iam_role.jenkins_ecr_access_role.arn]
  }
}

resource "aws_iam_policy" "jenkins_eks_access_policy" {
  name        = "${var.environment}-jenkins-eks-access-policy"
  description = "Policy for Jenkins to interact with EKS resources"
  policy      = data.aws_iam_policy_document.jenkins_eks_access_policy.json
}

resource "aws_iam_role_policy_attachment" "jenkins_ecr_access" {
  policy_arn = var.ecr_access_policy_arn
  role       = aws_iam_role.jenkins_ecr_access_role.name
}

resource "aws_iam_role_policy_attachment" "jenkins_eks_access" {
  policy_arn = aws_iam_policy.jenkins_eks_access_policy.arn
  role       = aws_iam_role.jenkins_ecr_access_role.name
}

// Update the Kubernetes service account with additional annotations
resource "kubernetes_service_account" "jenkins_sa" {
  metadata {
    name      = "jenkins-sa"
    namespace = "jenkins"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.jenkins_ecr_access_role.arn
    }
  }
}

// Create a Kubernetes cluster role for full access
resource "kubernetes_cluster_role" "jenkins_admin_role" {
  metadata {
    name = "jenkins-admin-role"
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

// Bind the cluster role to the Jenkins service account
resource "kubernetes_cluster_role_binding" "jenkins_admin_binding" {
  metadata {
    name = "jenkins-admin-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.jenkins_admin_role.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.jenkins_sa.metadata[0].name
    namespace = kubernetes_service_account.jenkins_sa.metadata[0].namespace
  }
}