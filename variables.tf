variable "tags" {
  description = "Map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "git" {
  description = "Name of the Git repo"
  type        = string
}

variable "lambda_policy" {
  type        = any
  description = "point to data.aws_iam_policy_document.custom.json"
  default     = null
}

variable "s3_inventory_bucket" {
  description = "s3 inventory bucket"
  type        = string
}

variable "schedule_expression_inventory" {
  description = "event schedule for lambda inventory report"
  type        = string
  default     = "cron(00 19 ? * * *)" # run daily at 7pm UTC
}