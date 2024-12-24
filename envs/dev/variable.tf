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
variable "rule_config" {
  description = <<EOF
EventBridge ルール設定
s3_object_key_filter = pref
EOF
  type = map(object({
    s3_object_key_filter = list(object({
      prefix = string
    }))
    command_args = list(string)
  }))
}

variable "schedule_config" {
  description = "EventBridge スケジューラー設定"
  # description = <<EOF
  #   # schedule_expression
  #   https://docs.aws.amazon.com/ja_jp/scheduler/latest/UserGuide/schedule-types.html

  #   # command_args
  #   https://docs.docker.jp/engine/reference/builder.html#cmd
  #   ```
  #   bash
  #   ```
  # EOF
  type = map(object({
    schedule_expression = string
    command_args        = list(string)
  }))
}

