resource "aws_ecr_repository" "this" {
  name                 = "${var.environment}-${var.repository_name}"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "KMS"
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 30 images"
      selection = {
        tagStatus     = "any"
        countType     = "imageCountMoreThan"
        countNumber   = 30
      }
      action = {
        type = "expire"
      }
    }]
  })
}

data "aws_iam_policy_document" "ecr_access" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload"
    ]
    resources = [aws_ecr_repository.this.arn]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }
}


resource "aws_iam_policy" "ecr_access" {
  name        = "${var.environment}-ecr-access-policy"
  path        = "/"
  description = "Policy to allow EKS nodes to pull and push images from ECR"
  policy      = data.aws_iam_policy_document.ecr_access.json
}


//attaching ecs policy to eks worker node role 
resource "aws_iam_role_policy_attachment" "ecr_access" {
  policy_arn = aws_iam_policy.ecr_access.arn
  role       = var.eks_node_role_name
}