#--------------------------------------------------------------
# General
#--------------------------------------------------------------

region   = "ap-northeast-1"
app_name = "eventbridge-sample-kishi"
env      = "dev"

ecs_cluster_arn             = "arn:aws:ecs:ap-northeast-1:220511012178:cluster/batch-cluster"
ecs_task_execution_role_arn = "arn:aws:iam::220511012178:role/ecs_task_execution_role"
# [AWS]ECS+EventBridgeで最新リビジョンでタスクを実行できるようにするためのTerraformの設定
# https://zenn.dev/optfit_tech/articles/5e6ee38a8810ad
task_definition_arn = "arn:aws:ecs:ap-northeast-1:220511012178:task-definition/batch-task"

vpc_id             = "vpc-0d83b785b019ce638"
ecs_subnets        = ["subnet-0304ea1c1e04af0e7", "subnet-01aa90ffb02b25935"]
ecs_security_group = "sg-07a4db666c4904041"

efs_file_system_id  = "fs-07cb6b25f70c9477b"
efs_access_point_id = "fsap-0455c0d30d476160e"

object_key_filter = [
  { prefix = "aaa/" },
  { prefix = "bbb/" }
]
command_args = [
  "echo",
  "hello hello"
]

