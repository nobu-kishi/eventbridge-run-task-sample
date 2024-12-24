# region   = "ap-northeast-1"
app_name = "eventbridge-sample-kishi"
env      = "dev"

# ECS
ecs_cluster_arn = "arn:aws:ecs:ap-northeast-1:220511012178:cluster/batch-cluster"

# EFS
# NOTE: 命名規則が一貫している場合、動的参照させた方が良い
efs_file_system_id  = "fs-023f39052120c7636"
efs_access_point_id = "fsap-01e93b8441fafef36"

# VPC
vpc_id                  = "vpc-0d83b785b019ce638"
ecs_subnet_name_list    = ["public-subnet-0", "public-subnet-1"]
ecs_security_group_name = "ecs-test"


# ルール
# TODO: 要件に合わせて、設定値の簡略化・変数名の具体化を行う
#   例
#   sample_rule = {
#     trigger_s3_prefix_path_list = [ "aaa/", "bbb/" ]
#     shell_name = "hoge.sh"
#   }
rule_config = {
  rule1 = {
    s3_object_key_filter = [
      { prefix = "aaa/" },
      { prefix = "bbb/" }
    ]
    command_args = [
      "echo",
      "hello"
    ]
  }
  rule2 = {
    s3_object_key_filter = [
      { prefix = "ccc/" },
      { prefix = "ddd/" }
    ]
    command_args = [
      "echo",
      "hello hello"
    ]
  }
}

# スケジューラー
# TODO: ルールと同じ
schedule_config = {
  schedule1 = {
    schedule_expression = "cron(0 0 ? * MON-FRI *)"
    command_args = [
      "echo",
      "hello"
    ]
  }
  schedule2 = {
    schedule_expression = "cron(0 0 ? * MON *)"
    command_args = [
      "echo",
      "hello hello"
    ]
  }
}