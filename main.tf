locals {
  tags = {
    cost    = "shared"
    creator = "terraform"
    git     = var.git
  }
}

data "archive_file" "lambda_zip" {
  type             = "zip"
  output_file_mode = "0666"
  source_file      = "${path.module}/inventory_report.py"
  output_path      = "${path.module}/inventory_report.zip"
}