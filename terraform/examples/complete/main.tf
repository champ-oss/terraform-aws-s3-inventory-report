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

module "s3" {
  source  = "github.com/champ-oss/terraform-aws-s3.git?ref=v1.0.40-137c64b"
  git     = "terraform-aws-s3-inventory"
  protect = false
}

module "this" {
  source              = "../../"
  lambda_policy       = data.aws_iam_policy_document.this.json
  s3_inventory_bucket = module.s3.bucket
}
