# タスク定義
module "ecs_task" {
  source   = "../../module/common/ecs-task"
  app_name = var.app_name
  env      = var.env

  ecs_cluster_arn = var.ecs_cluster_arn
  efs_file_system_id  = var.efs_file_system_id
  efs_access_point_id = var.efs_access_point_id
}

# ルール
# TODO:複数動的にルールやスケジューラーを作成できるようにする
module "rule" {
  # for_each = var.rule_config

  source   = "../../module/ecs_task_for_s3"
  app_name = var.app_name
  env      = var.env

  rule_config = var.rule_config
  # s3_object_key_filter = var.s3_object_key_filter
  ecs_cluster_arn                = var.ecs_cluster_arn
  ecs_task_definition_arn_latest = module.ecs_task.ecs_task_definition_arn_latest
  vpc_id                = var.vpc_id
  ecs_subnet_id_list    = data.aws_subnets.ecs_subnets.ids
  ecs_security_group_id = data.aws_security_group.ecs_security_group.id
  # command_args          = var.command_args
  # shell_name         = var.shell_name
  # efs_base_path      = var.efs_base_path

  # s3_object_key_filter =  value.s3_object_key_filter
  # command_args          = each.value.command_args
}

# module "scheduler" {
#   source = "../../module/ecs_task_for_scheduled"

#   env          = var.env
#   app_name      = var.app_name

#   # タスク定義関連
#   ecs_cluster_arn     = var.ecs_cluster_arn
#   task_definition_arn = var.task_definition_arn
#   role_arn        = var.batch_role_arn
#   ecs_task_execution_role_arn = var.ecs_task_execution_role_arn
#   access_point_id = var.access_point_id
#   file_system_id  = var.efs_file_system_id

#   vpc_id          = var.vpc_id
#   ecs_subnet_list       = var.ecs_subnet_list


#   shell_efs_path = local.shell_efs_path
#   cron            = "cron(0 5 ? * 2-6 *)"
# }each.
