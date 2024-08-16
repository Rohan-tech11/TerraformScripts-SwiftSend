terraform {
  backend "s3" {
    bucket         = "staging-tfstate-bucket"
    key            = "staging/terraform.tfstate"
    region         = "ca-central-1"
    dynamodb_table = "staging-tfstate-lock"
    encrypt        = true
  }
}
 