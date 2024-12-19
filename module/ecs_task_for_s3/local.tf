# 定数
locals {
  _TMP_PREFIX                    = "${var.env}-${var.app_name}"
  ECS_CONTAINER_NAME                 = "run-task"
  EVENTBRIDGE_RULE_ROLE_NAME     = "${local._TMP_PREFIX}-eventbridge-rule-role"
  EVENTBRIDGE_SRC_S3_BUCKET_NAME = "${local._TMP_PREFIX}-bucket"
}