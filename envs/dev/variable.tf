variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "env" {
  description = "Prefix for resource names"
  type        = string
  # default     = "dev"
}

# 
# タスク定義
#
variable "app_name" {
  description = "app name"
  type        = string
}

variable "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  type        = string
  default     = "arn:aws:ecs:region:account-id:cluster/your-dev-cluster"
}

variable "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task role"
  type        = string
  # default     = "arn:aws:ecs:region:account-id:task-definition/your-task:1"
}

variable "task_definition_arn" {
  description = "ARN of the ECS task definition"
  type        = string
  default     = "arn:aws:ecs:region:account-id:task-definition/your-task:1"
}

# 
# EFS
# 
variable "efs_file_system_id" {
  description = "The EFS file system ID"
  type        = string
  # default     = "fs-12345678"
}

variable "efs_access_point_id" {
  description = "The EFS access point ID"
  type        = string
  # default     = "fsap-87654321"
}

# variable "efs_base_path" {
#   description = "Assign a public IP to the task"
#   type        = string
#   default     = "/efs/mnt"
# }

# 
# VPC
# 
variable "vpc_id" {
  description = "vpc-id"
  type        = string
  # default     = "fsap-87654321"
}

variable "ecs_subnets" {
  description = "List of subnet IDs for the task"
  type        = list(string)
  # default     = ["subnet-1234567890abcdef0", "subnet-0abcdef1234567890"]
}

variable "ecs_security_group" {
  description = "List of security group IDs for the task"
  type        = string
  # default     = ["sg-12345678"]
}


#
# EventBridge
#
variable "object_key_filter" {
  description = "List of object key filters with prefix"
  type = list(object({
    prefix = string
  }))
}

# TODO: リスト形式にする？
variable "command_args" {
  description = "ShellScript name"
  type        = list(string)
}