provider "aws" {
  region = var.aws_region
}

resource "aws_dynamodb_table" "tfstate_lock" {
  name         = "${var.environment}-tfstate-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "${var.environment}-tfstate-lock"
    Environment = var.environment
  }
}