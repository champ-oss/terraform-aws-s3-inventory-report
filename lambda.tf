module "cloud_inventory_report" {
  source                   = "github.com/champ-oss/terraform-aws-lambda.git?ref=v1.0.119-2052713"
  git                      = var.git
  name                     = "inventory-lambda"
  tags                     = merge(local.tags, var.tags)
  enable_cw_event          = true
  schedule_expression      = var.schedule_expression_inventory
  sync_image               = true
  sync_source_repo         = "champtitles/terraform-aws-s3-inventory"
  ecr_name                 = "${var.git}-lambda"
  ecr_tag                  = module.hash.hash
  enable_custom_iam_policy = false
  timeout                  = 900
  environment = {
    S3_INVENTORY_BUCKET = var.s3_inventory_bucket
  }
}
