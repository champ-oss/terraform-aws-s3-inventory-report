module "cloud_inventory_report" {
  source                         = "github.com/champ-oss/terraform-aws-lambda.git?ref=v1.0.119-2052713"
  git                            = var.git
  name                           = "inventory-lambda"
  tags                           = merge(local.tags, var.tags)
  runtime                        = "python3.9"
  enable_cw_event                = true
  schedule_expression            = var.schedule_expression_inventory
  timeout                        = 900
  handler                        = "inventory_report.lambda_handler"
  sync_image                     = false
  filename                       = data.archive_file.lambda_zip.output_path
  source_code_hash               = data.archive_file.lambda_zip.output_base64sha256
  reserved_concurrent_executions = 1
  environment = {
    S3_INVENTORY_BUCKET = var.s3_inventory_bucket
  }
}