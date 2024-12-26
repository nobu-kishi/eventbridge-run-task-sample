# タスク定義
module "ecs_task" {
  source   = "../../modules/common/ecs-task"
  app_name = var.app_name
  env      = var.env

  ecs_cluster_arn     = var.ecs_cluster_arn
  efs_file_system_id  = var.efs_file_system_id
  efs_access_point_id = var.efs_access_point_id
}

# ルール
module "rule" {
  source   = "../../modules/ecs_task_for_s3"
  app_name = var.app_name
  env      = var.env

  ecs_cluster_arn                = var.ecs_cluster_arn
  ecs_task_definition_arn_latest = module.ecs_task.ecs_task_definition_arn_latest
  vpc_id                         = var.vpc_id
  ecs_subnet_id_list             = data.aws_subnets.ecs_subnets.ids
  ecs_security_group_id          = data.aws_security_group.ecs_security_group.id
  rule_config                    = var.rule_config
}

# スケジューラー
module "scheduler" {
  source   = "../../modules/ecs_task_for_scheduled"
  app_name = var.app_name
  env      = var.env

  ecs_cluster_arn                = var.ecs_cluster_arn
  ecs_task_definition_arn_latest = module.ecs_task.ecs_task_definition_arn_latest
  vpc_id                         = var.vpc_id
  ecs_subnet_id_list             = data.aws_subnets.ecs_subnets.ids
  ecs_security_group_id          = data.aws_security_group.ecs_security_group.id
  schedule_config                = var.schedule_config
}
