#
# EventBridge ルールの作成
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule
resource "aws_cloudwatch_event_rule" "schedule_rule" {
  name                = "nightly-batch-rule"
  schedule_expression = "cron(0 2 * * ? *)"
}

# EventBridge ターゲット用 IAM ロール
resource "aws_iam_role" "eventbridge_target_role" {
  name = "eventbridge-target-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "events.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eventbridge_target_policy" {
  role       = aws_iam_role.eventbridge_target_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}

# EventBridge ターゲットの作成
resource "aws_cloudwatch_event_target" "ecs_target" {
  rule = aws_cloudwatch_event_rule.schedule_rule.name
  arn  = aws_ecs_cluster.ecs_cluster.arn

  ecs_target {
    launch_type         = "FARGATE"
    task_definition_arn = aws_ecs_task_definition.batch_task.arn
    network_configuration {
      assign_public_ip = true
      subnets          = aws_subnet.public[*].id
      security_groups  = [aws_security_group.efs_sg.id]
    }
    platform_version = "LATEST"
  }

  role_arn = aws_iam_role.eventbridge_target_role.arn
}