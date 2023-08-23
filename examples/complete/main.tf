provider "aws" {
  region = "us-east-2"
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = [
      "s3:*",
    ]
    resources = ["*"]
  }
}

module "this" {
  source        = "../../"
  git           = var.git
  lambda_policy = data.aws_iam_policy_document.this.json
}