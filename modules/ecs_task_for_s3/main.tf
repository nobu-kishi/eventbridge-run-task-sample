#
# S3
#

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "bucket" {
  bucket        = local.EVENTBRIDGE_SRC_S3_BUCKET_NAME
  force_destroy = true
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
# EventBridge ルール
#

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule
resource "aws_cloudwatch_event_rule" "s3_event_rule" {
  for_each = var.rule_config

  name = "${local._TMP_PREFIX}-${each.key}"
  event_pattern = jsonencode({
    source      = ["aws.s3"],
    detail-type = ["Object Created"],
    detail = {
      bucket = {
        name = ["${local.EVENTBRIDGE_SRC_S3_BUCKET_NAME}"]
      },
      object = {
        key = "${each.value.s3_object_key_filter}"
      }
    }
  })
}

# EventBridge ターゲット用 IAMロール
resource "aws_iam_role" "eventbridge_rule_role" {
  name = local.EVENTBRIDGE_RULE_ROLE_NAME

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

# EventBridge ターゲット
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target#ecs-run-task-with-role-and-task-override-usage
resource "aws_cloudwatch_event_target" "ecs_target" {
  for_each = var.rule_config

  # NOTE: 変数の受け渡しが複雑化するためモジュール内で設定する
  arn      = var.ecs_cluster_arn
  rule     = "${local._TMP_PREFIX}-${each.key}"
  role_arn = aws_iam_role.eventbridge_rule_role.arn

  ecs_target {
    launch_type         = "FARGATE"
    task_definition_arn = var.ecs_task_definition_arn_latest
    network_configuration {
      assign_public_ip = true
      subnets          = var.ecs_subnet_id_list
      security_groups  = [var.ecs_security_group_id]
    }
    platform_version = "LATEST"
  }

  input = jsonencode({
    containerOverrides = [
      {
        name    = "${local.ECS_CONTAINER_NAME}",
        command = "${each.value.command_args}"
      }
    ]
  })

  depends_on = [aws_cloudwatch_event_rule.s3_event_rule]
}