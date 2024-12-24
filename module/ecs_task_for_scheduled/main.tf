#
# EventBridge スケジューラー
#

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule
resource "aws_scheduler_schedule" "schedule" {
  for_each = var.schedule_config


  name = "${local._TMP_PREFIX}-${each.key}"
  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression          = each.value.schedule_expression
  schedule_expression_timezone = "Asia/Tokyo"

  target {
    arn      = var.ecs_cluster_arn
    role_arn = aws_iam_role.eventbridge_target_role.arn

    ecs_parameters {
      launch_type         = "FARGATE"
      platform_version    = "LATEST"
      task_definition_arn = var.ecs_task_definition_arn_latest
      network_configuration {
        assign_public_ip = true
        subnets          = var.ecs_subnet_id_list
        security_groups  = [var.ecs_security_group_id]
      }

    }
    input = jsonencode({
      containerOverrides = [
        {
          name    = "${local.ECS_CONTAINER_NAME}",
          command = "${each.value.command_args}"
        }
      ]
    })
  }
}

# EventBridge ターゲット用 IAM ロール
resource "aws_iam_role" "eventbridge_target_role" {
  name = local.EVENTBRIDGE_SCHEDULE_ROLE_NAME

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "scheduler.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eventbridge_target_policy" {
  role       = aws_iam_role.eventbridge_target_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}