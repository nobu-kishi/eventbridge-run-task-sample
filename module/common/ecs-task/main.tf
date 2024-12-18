#
# タスク定義の作成
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition
resource "aws_ecs_task_definition" "batch_task" {
  family                   = "batch-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.ecs_task_execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "shell-container"
      image     = "amazonlinux:latest"
      essential = true
      command   = ["echo", "Hello World"]
      mountPoints = [
        {
          sourceVolume  = "efs-volume"
          containerPath = "/mnt/efs"
          readOnly      = false
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/shell-task"
          awslogs-region        = "ap-northeast-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  volume {
    name = "efs-volume"

    efs_volume_configuration {
      file_system_id = var.efs_file_system_id
    }
  }

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }
}

# CloudWatch Logs グループの作成
# MEMO: 一旦、ルールとスケジューラーでタスク定義を分ける想定
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name = "/ecs/shell-task"
  # name              = "/ecs/${var.prefix}-shell-task"
  retention_in_days = 7
}