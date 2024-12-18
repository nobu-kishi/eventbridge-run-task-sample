# provider "aws" {
#   region = var.region
# }

provider "aws" {
  region = "ap-northeast-1" # 東京リージョン
}

# locals {
#   project_name = "${var.env}-${var.name}"
# }

# locals {
#   shell_efs_path = "${efs_base_path}/${shell_name}"
# }

terraform {
  required_version = ">=1.9.8"
  required_providers {
    aws = {
      version = "~> 5.42.0"
      source  = "hashicorp/aws"
    }
  }
  # backend "s3" {
  #   bucket = "dev-ecs-exe-shell-kishi"
  #   key    = "terraform.tfstate"
  #   region = "ap-northeast-1"
  # }
}


#
# タスク定義
#
# module "ecs_task" {
#   source   = "../../module/common/ecs-task"
#   env      = var.env
#   app_name = var.app_name

#   # タスク定義関連
#   ecs_cluster_arn         = var.ecs_cluster_arn
#   task_definition_arn = var.task_definition_arn
#   efs_file_system_id  = var.efs_file_system_id
#   efs_access_point_id = var.efs_access_point_id
# }


# TODO:複数動的にルールやスケジューラーを作成できるようにする
module "rule" {
  source   = "../../module/ecs_task_for_s3"
  env      = var.env
  app_name = var.app_name

  # タスク定義関連
  ecs_cluster_arn     = var.ecs_cluster_arn
  task_definition_arn = var.task_definition_arn
  efs_file_system_id  = var.efs_file_system_id
  efs_access_point_id = var.efs_access_point_id

  # EventBridge Rule
  object_key_filter = var.object_key_filter
  # shell_name         = var.shell_name
  # efs_base_path      = var.efs_base_path
  command_args       = var.command_args
  vpc_id             = var.vpc_id
  ecs_subnets        = var.ecs_subnets
  ecs_security_group = var.ecs_security_group
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
#   ecs_subnets       = var.ecs_subnets


#   shell_efs_path = local.shell_efs_path
#   cron            = "cron(0 5 ? * 2-6 *)"
# }
