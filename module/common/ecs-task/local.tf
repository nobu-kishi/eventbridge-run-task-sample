# 定数
locals {
  _TMP_PREFIX = "${var.env}-${var.app_name}"

  ECS_CONTAINER_NAME            = "run-task"
  ECS_CONTAINER_IMAGE_URI       = "amazonlinux:latest"
  ECS_TASK_NAME                 = "${local._TMP_PREFIX}-task-sample"
  ECS_TASK_EXECUTION_ROLE_NAME  = "${local._TMP_PREFIX}-ECSTaskExecutionRole"
  ECS_CLOUDWATCH_LOGS_LOG_GROUP = "/ecs/${local._TMP_PREFIX}-sample"

  EFS_NAME          = "${var.env}-main-efs"
  EFS_CONTAINERPATH = "/mnt/efs"
}