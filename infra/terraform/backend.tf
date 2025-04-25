terraform {
  required_version = ">= 1.2"
  backend "s3" {
    bucket         = "gitops-platform-tf-state-tmac"
    key            = "eks-gitops/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-state-locks"
    encrypt        = true
  }
}
