#
# EFS
#

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/efs_file_system
data "aws_efs_file_system" "ecs_volume" {
  tags = {
    Name = local.EFS_NAME
  }
}

# data "aws_efs_access_point" "id" {
#   access_point_id = data.aws_efs_file_system.ecs_volume.id
# }

#
# ECS
#
data "aws_iam_role" "ecs_task_exec_role" {
  name = local.ECS_TASK_EXECUTION_ROLE_NAME
}