module "cloud_inventory_report" {
  source              = "github.com/champ-oss/terraform-aws-lambda.git?ref=v1.0.119-2052713"
  git                 = var.git
  name                = "inventory-lambda"
  tags                = merge(local.tags, var.tags)
  runtime             = "python3.9"
  enable_cw_event     = true
  schedule_expression = var.schedule_expression_inventory
  timeout             = 900
  handler             = "inventory_report.lambda_handler"
  environment = {
    S3_INVENTORY_BUCKET = var.s3_inventory_bucket
  }
}