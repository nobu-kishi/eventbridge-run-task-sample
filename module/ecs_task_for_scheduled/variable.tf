#
# 全般
#
variable "app_name" {
  description = "アプリケーション名"
  type        = string
}

variable "env" {
  description = "環境名"
  type        = string
}

# 
# タスク定義
#
variable "ecs_cluster_arn" {
  description = "ECSクラスターのARN"
  type        = string
}

variable "ecs_task_definition_arn_latest" {
  description = "ECSタスク定義のARN（リビジョン番号なし）"
  type        = string
}

# VPC
# 
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "ecs_subnet_id_list" {
  description = "タスク用サブネットIDのリスト"
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "タスク用セキュリティグループID"
  type        = string
}

#
# EventBridge
#
variable "schedule_config" {
  description = "EventBridge スケジューラー設定"
  type = map(object({
    schedule_expression = string
    command_args        = list(string)
  }))
}