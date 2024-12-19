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

# 
# EFS
# 
variable "efs_file_system_id" {
  description = "EFSファイルシステムID"
  type        = string
}

variable "efs_access_point_id" {
  description = "EFSアクセスポイントID"
  type        = string
}

# 
# VPC
# 
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "ecs_subnet_name_list" {
  description = "タスク用サブネット名のリスト"
  type        = list(string)
}

variable "ecs_security_group_name" {
  description = "タスク用セキュリティグループ名"
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