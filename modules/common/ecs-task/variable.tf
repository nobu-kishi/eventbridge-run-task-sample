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