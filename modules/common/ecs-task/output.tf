output "ecs_task_definition_arn_latest" {
  value = aws_ecs_task_definition.run_task.arn_without_revision
}