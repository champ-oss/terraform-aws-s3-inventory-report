module "cloud_inventory_report" {
  source                   = "github.com/champ-oss/terraform-aws-lambda.git?ref=v1.0.141-e8ebe65"
  git                      = var.git
  name                     = "s3-inventory-report"
  tags                     = merge(local.tags, var.tags)
  enable_cw_event          = true
  schedule_expression      = var.schedule_expression_inventory
  sync_image               = true
  sync_source_repo         = "champtitles/s3-inventory-report"
  ecr_name                 = "s3-inventory-report"
  ecr_tag                  = module.hash.hash
  enable_custom_iam_policy = false
  timeout                  = 900
  memory_size              = var.memory_size
  environment = {
    S3_INVENTORY_BUCKET = var.s3_inventory_bucket
  }
}
