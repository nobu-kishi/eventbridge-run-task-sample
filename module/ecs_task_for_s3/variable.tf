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

# 
# EFS
# 
# variable "efs_base_path" {
#   type        = string
#   default     = "/efs/mnt"
# }

# 
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
# variable "s3_object_key_filter" {
#   description = "S3オブジェクトのキーフィルターリスト"
#   type = list(object({
#     prefix = string
#   }))
# }

# # TODO: Map形式にする？
# variable "command_args" {
#   description = "command or {シェルスクリプト名}"
#   type        = list(string)
# }


variable "rule_config" {
  description = "EventBridge ルール設定"
  type = map(object({
    s3_object_key_filter = list(object({
      prefix = string
    }))
    command_args = list(string)
  }))
}