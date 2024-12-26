# 定数
locals {
  _TMP_PREFIX                    = "${var.env}-${var.app_name}"
  ECS_CONTAINER_NAME             = "run-task"
  EVENTBRIDGE_SCHEDULE_ROLE_NAME = "${local._TMP_PREFIX}-eventbridge-suchedule-role"
  EVENTBRIDGE_SRC_S3_BUCKET_NAME = "${local._TMP_PREFIX}-bucket"
}