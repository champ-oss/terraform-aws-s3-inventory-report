module "cloud_inventory_report" {
  source                   = "github.com/champ-oss/terraform-aws-lambda.git?ref=v1.0.119-2052713"
  git                      = var.git
  name                     = "s3-inventory-report"
  tags                     = merge(local.tags, var.tags)
  enable_cw_event          = true
  schedule_expression      = var.schedule_expression_inventory
  sync_image               = true
  sync_source_repo         = "champtitles/s3-inventory-report"
  ecr_name                 = "s3-inventory-report"
  ecr_tag                  = var.s3_inventory_report_docker_tag
  enable_custom_iam_policy = false
  timeout                  = 900
  environment = {
    S3_INVENTORY_BUCKET = var.s3_inventory_bucket
  }
}
