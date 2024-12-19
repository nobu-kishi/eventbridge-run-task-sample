#
# タスク定義の作成
#
# NOTE: タスク定義はルールとスケジューラーで共有する前提のコード

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition
resource "aws_ecs_task_definition" "run_task" {
  family                   = local.ECS_TASK_NAME
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = data.aws_iam_role.ecs_task_exec_role.arn
  task_role_arn            = data.aws_iam_role.ecs_task_exec_role.arn

  container_definitions = jsonencode([
    {
      name      = local.ECS_CONTAINER_NAME
      image     = "amazonlinux:latest"
      essential = true
      command   = ["echo", "Hello World"]
      mountPoints = [
        {
          sourceVolume  = local.EFS_NAME
          containerPath = local.EFS_CONTAINERPATH
          readOnly      = false
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = local.ECS_CLOUDWATCH_LOGS_LOG_GROUP
          awslogs-region        = "ap-northeast-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  volume {
    name = local.EFS_NAME

    efs_volume_configuration {
      file_system_id          = data.aws_efs_file_system.ecs_volume.id
      root_directory          = "/"
      transit_encryption      = "ENABLED"
      transit_encryption_port = 0

      authorization_config {
        access_point_id = var.efs_access_point_id
      }
    }
  }

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name = local.ECS_CLOUDWATCH_LOGS_LOG_GROUP
  retention_in_days = 1
}