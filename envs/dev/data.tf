# NOTE: ルール・スケジュラーでともに利用するため、上位で持ちたい

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group
data "aws_security_group" "ecs_security_group" {
  name = var.ecs_security_group_name
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets
data "aws_subnets" "ecs_subnets" {
  filter {
    name   = "tag:Name"
    values = var.ecs_subnet_name_list
  }
}