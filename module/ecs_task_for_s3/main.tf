locals {
  prefix        = "${var.env}-${var.app_name}"
  cotainer_name = "batch-container"
}

#
# S3
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "bucket" {
  bucket = "${local.prefix}-bucket"

  tags = {
    Name        = var.app_name
    Environment = var.env
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block
resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket      = aws_s3_bucket.bucket.id
  eventbridge = true
}


#
# EventBridge ルールの作成
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule
resource "aws_cloudwatch_event_rule" "schedule_rule" {
  name = "${local.prefix}-rule"

  event_pattern = jsonencode({
    source      = ["aws.s3"],
    detail-type = ["Object Created"],
    detail = {
      bucket = {
        name = ["${local.prefix}-bucket"]
      },
      object = {
        key = "${var.object_key_filter}"
      }
    }
  })
}

# EventBridge ターゲット用 IAM ロール
resource "aws_iam_role" "eventbridge_rule_role" {
  name = "${local.prefix}-eventbridge-rule-role"

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

resource "aws_iam_role_policy_attachment" "eventbridge_policy" {
  role       = aws_iam_role.eventbridge_rule_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}

# EventBridge ターゲットの作成
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target#ecs-run-task-with-role-and-task-override-usage
resource "aws_cloudwatch_event_target" "ecs_target" {
  rule = aws_cloudwatch_event_rule.schedule_rule.name
  arn  = var.ecs_cluster_arn

  ecs_target {
    launch_type         = "FARGATE"
    task_definition_arn = var.task_definition_arn
    network_configuration {
      assign_public_ip = true
      subnets          = var.ecs_subnets
      security_groups  = [var.ecs_security_group]
    }
    platform_version = "LATEST"
  }
  input = jsonencode({
    containerOverrides = [
      {
        name    = "${local.cotainer_name}",
        command = "${var.command_args}"
      }
    ]
  })

  role_arn = aws_iam_role.eventbridge_rule_role.arn
}